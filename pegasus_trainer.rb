Shoes.app do
  $workout = []
  background black
  stack do
    stack do
      background hotpink
      stroke black
      title "Pegasus Trainer"
    end
    stack(:margin => 10,:padding => 5) do
      border pink
      flow(:margin => 5) {
        flow(:width => 80) { para "Duration", :stroke => hotpink }
        @duration = edit_line
      }
      flow(:margin => 5) {
        flow(:width => 80) { para "BPM", :stroke => hotpink }
        @bpm = edit_line
      }
      
      button "Add Stage" do
        secs = @duration.text.split(':')[1].to_i
        secs += @duration.text.split(':')[0].to_i * 60
        $workout << {:duration => @duration.text,
                     :bpm => @bpm.text,
                     :seconds => secs
                    }
        @duration.text = ''
        @bpm.text = ''
        @workout_flow.clear { $workout.each do |stage|
          para "#{stage[:duration]}, #{stage[:bpm]}BPM", :stroke => hotpink
        end }
      end
    end
    stack(:margin => 10, :padding => 5) do
      border pink
      subtitle "Workout Plan", :stroke => hotpink
      @workout_flow = stack {}
      flow do
        button "clear" do
          @workout_flow.clear
          $workout = []
        end
        button "start workout" do
          window(:width => 650, :height => 100) do
            def seconds_to_time(seconds)
              hours = mins = 0
              if seconds >=  60 then
                mins = (seconds / 60).to_i 
                seconds = (seconds % 60 ).to_i

                if mins >= 60 then
                  hours = (mins / 60).to_i 
                  mins = (mins % 60).to_i
                end
              end
              "%02d:%02d:%02d" % [hours,mins,seconds]
            end

            #player
            @current_stage_number = 0
            @stage = $workout[@current_stage_number]
            @start = Time.now.to_i
            @stage_start = Time.now.to_i
            @total_time = $workout.inject(0){|acc,s| acc+=s[:seconds]}
            animate(5) do
              clear
              background black
              stroke hotpink
              flow do
                now = Time.now.to_i
                elapsed = now-@stage_start
                remaining = @stage[:seconds]-elapsed
                total_elapsed = now-@start
                total_remaining = @total_time-total_elapsed
                stack(:width => 120) {
                  para "Stage", :stroke => hotpink
                  para @current_stage_number+1, :stroke => hotpink
                }
                stack(:width => 180) {
                  para "Stage Time", :stroke => hotpink
                  para seconds_to_time(elapsed),
                       " / ",seconds_to_time(remaining), :stroke => hotpink
                }
                stack(:width => 180) {
                  para "Total Time", :stroke => hotpink
                  para seconds_to_time(total_elapsed)," / ",
                       seconds_to_time(total_remaining), :stroke => hotpink
                }
                stack(:width => 140) { para "Target BPM", :stroke => hotpink; para @stage[:bpm], :stroke => hotpink}

                if remaining < 1
                  if @current_stage_number+2 > $workout.length
                    clear
                    title "Your workout is complete.", :stroke => hotpink
                  else
                    @current_stage_number += 1
                    @stage_start = Time.now.to_i
                    @stage = $workout[@current_stage_number]
                  end
                end
              end 
              
            end
          end
        end
      end
    end


  end
end
