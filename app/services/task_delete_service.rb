class TaskDeleteService
    def self.task_delete(text)
        title = text.delete('削除').delete("\n")
        task = Task.find_by(title: title)

        if task
            task.destroy
            message = "#{title}を削除しました。"
        else
            message = "該当するタスクが見つかりませんでした。"
        end
        message
    end
end