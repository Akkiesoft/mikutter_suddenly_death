# -*- coding: utf-8 -*-

# http://d.hatena.ne.jp/ux00ff/20120721/1342878538
class String
  def screen_width
    hankaku_len = self.each_char.count {|x| x.ascii_only? }
    hankaku_len + (self.size - hankaku_len) * 2
  end
end

Plugin.create :mikutter_suddenly_death do
	command(:suddenly_death,
		name: '突然の死',
		condition: lambda{ |opt| true },
		visible: true,
		role: :postbox
	) do |opt|
		begin
			max_length = 0
			postbox = Plugin[:gtk].widgetof(opt.widget).widget_post

			# メッセージを取得してバラバラにする（意味深）
			message = postbox.buffer.text.split("\n")
			message.each do |line|
				# 一番長い行を調べる
				length = line.screen_width / 2 + 1
				if max_length < length then
					max_length = length
				end
			end

			# 上下のアレをアレする
			i = 0
			line1 = "＿人"
			line3 = "￣^"
			while max_length != i do
				line1 += "人"
				line3 += "Y^"
				i += 1
			end

			# ツイーヨをつくります
			str = line1 + "＿\n"
			message.each do |line|
				i = line.screen_width / 2 + 1
				while max_length != i do
					line += "　"
					i += 1
				end
				str += "＞　#{line}　＜\n"
			end
			str += line3 + "￣"

			# 突然の死
			if UserConfig[:suddenly_death_immediate] then
				Service.primary.post(:message => str)
				postbox.buffer.text = ""
			else
				postbox.buffer.text = str
			end
		end
	end

	settings "突然の死" do
		boolean('すぐに投稿する', :suddenly_death_immediate)
	end
end
