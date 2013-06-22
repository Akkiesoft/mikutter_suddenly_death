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
			message = Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text
			length = message.screen_width / 2 + 1
			line1 = ""
			line3 = ""
			i = 0
			while length != i do
				line1 += "人"
				line3 += "Y^"
				i += 1
			end
			str =	"＿人" + line1 + "＿\n" + 
					"＞　#{message}　＜\n" +
					"￣^" + line3 + "￣"
			Post.primary_service.update(:message => str)
			Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text = ''
		end
	end
end
