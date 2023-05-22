class TaskCreateService
    def self.task_register(text)
        subject, deadline = ""

        text.delete('登録').delete("\n").split('、').each do |splitText|
            slitText = splitText.split(/\D+/)

            if splitText.match?(/\d+/)
                deadline = splitText
            else
                subject = splitText
            end
        end

        if subject.present? && deadline.present? && deadline.length >= 3
            checked = DeadlineProcessing.check_deadline(deadline.to_i)
            if checked.include?("過")
                message = checked
            else
                day = DeadlineProcessing.change_to_day(deadline.to_i)

                Task.create!(title: subject, deadline: deadline.to_i)
                message = "#{subject}の締め切りを、#{day}で登録しました。"
            end
        else
            message = "'、'で区切った上で、科目名と締め切りを入力してください。\n記述例：英語、101"
        end
        message
    end
end