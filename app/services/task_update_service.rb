class TaskUpdateService
    def self.task_update(text)
        title, deadline = ""

        text.delete('更新').delete("\n").split('、').each do |splitText|
            slitText = splitText.split(/\D+/)

            if splitText.match?(/\d+/)
                deadline = splitText
            else
                title = splitText
            end
        end

        if title.present? && deadline.present? && deadline.length >= 3
            checked = DeadlineProcessing.check_deadline(deadline.to_i)
            if checked.include?("過")
                message = checked
            else
                task = Task.find_by(title: title)
                if task
                    day = DeadlineProcessing.change_to_day(deadline.to_i)

                    task.update(deadline: deadline.to_i)
                    message = "#{title}の締め切りを、#{day}で更新しました。"
                else
                    message = "該当するタスクが見つかりませんでした。"
                end
            end
        else
            message = "'、'で区切った上で、科目名と締め切りを入力してください。\n記述例：英語、101"
        end
    end
end