class Message

  # max_tem_now: 昨日の最高気温
  # max_tem_old: 5日前から一昨日までの平均最高気温
  # min_tem_now: 昨日の最低気温
  # min_tem_old: 5日前から一昨日までの平均最低気温
  def self.create_message(max_tem_now, max_tem_old, min_tem_now, min_tem_old)
    # めっちゃ寒いね
    if min_tem_now < 0
      return ["めっちゃ寒いですね！", "昨日の最低気温0度以下だよ"]
    end
    # めっちゃ暑いね
    if max_tem_now >= 30
      return ["めっちゃ暑いですね！", "昨日の最高気温30度以上だよ"]
    end
    # 気温差激しいね
    if max_tem_now - min_tem_now >= 10
      return ["寒暖の差が激しいですね！", "昨日の最高気温、最低気温の気温差が10度以上"]
    end
    # 寒くなってきた
    if min_tem_now < min_tem_old && max_tem_now < max_tem_old
      return ["寒くなってきましたね！", "昨日の気温は、それ以前の3日間の平均より低い"]
    end
    # 暖かくなってきた
    if min_tem_now > min_tem_old && max_tem_now > max_tem_old
      return ["暖かくなってきましたね！", "昨日の気温は、それ以前の3日間の平均より高い"]
    end
    # 最終
    return ["最近、穏やかですね！", "特に変化のない日々"]
  end

end