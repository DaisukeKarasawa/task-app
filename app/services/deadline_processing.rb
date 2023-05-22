class DeadlineProcessing
    def self.check_deadline(day)
        currentDate = Date.today
        month = day / 100
        day = (day % 100) / 1

        deadline = Date.new(currentDate.year, month, day)

        if deadline > currentDate
            remain = (deadline - currentDate).to_i
            advice = remain >= 7 ? "期限まで余裕があるので、計画的に進めましょう。" : "１週間をきっています。気をつけて下さい。"
            message = "残り#{remain}日です。#{advice}"
        elsif deadline == currentDate
            message = "締め切りは本日です。課題を提出して下さい。"
        else
            message = "締め切りは過ぎています。"
        end
        message
    end

    def self.change_to_day(deadline)
        month = deadline / 100
        day = (deadline % 100 ) / 1

        return "#{month}月#{day}日"
    end
end