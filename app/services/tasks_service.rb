class TasksService
    def self.task_list
        tasks = Task.all

        if tasks.present?
            task_list = tasks.map {|task| "・#{task.title}: #{DeadlineProcessing.change_to_day(task.deadline)} (#{DeadlineProcessing.check_deadline(task.deadline)})"}.join("\n")
            message = "タスク一覧:\n\n#{task_list}"
        else
            message = "タスクがありません"
        end
        message
    end
end