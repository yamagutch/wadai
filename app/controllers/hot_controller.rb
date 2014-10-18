class HotController < ApplicationController
  require 'open-uri'
  require 'nokogiri'
  
  def index
    @prefecture_arr = [['1a','北海道（道北）'],['1b','北海道（道東）'],['1c','北海道（道央）'],['1d','北海道（道南）'],['2','青森県'],['3','岩手県'],['4','宮城県'],['5','秋田県'],['6','山形県'],['7','福島県'],['8','茨城県'],['9','栃木県'],['10','群馬県'],['11','埼玉県'],['12','千葉県'],['13','東京都'],['14','神奈川県'],['15','新潟県'],['16','富山県'],['17','石川県'],['18','福井県'],['19','山梨県'],['20','長野県'],['21','岐阜県'],['22','静岡県'],['23','愛知県'],['24','三重県'],['25','滋賀県'],['26','京都府'],['27','大阪府'],['28','兵庫県'],['29','奈良県'],['30','和歌山県'],['31','鳥取県'],['32','島根県'],['33','岡山県'],['34','広島県'],['35','山口県'],['36','徳島県'],['37','香川県'],['38','愛媛県'],['39','高知県'],['40','福岡県'],['41','佐賀県'],['42','長崎県'],['43','熊本県'],['44','大分県'],['45','宮崎県'],['46','鹿児島県'],['47','沖縄県']]
  end
  
  def region
    @prefecture_id = params[:prefecture_id]
    url = "http://weather.yahoo.co.jp/weather/jp/past/#{@prefecture_id}/"
    
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    
    doc = Nokogiri::HTML.parse(html, nil, charset)
    @region_arr = []
    doc.xpath('//a').each do |node|
      if node.to_s.include?("/weather/jp/past/#{@prefecture_id}")
        region_id = node.values[0].sub("/weather/jp/past/#{@prefecture_id}/", "").sub(".html", "")
        name = node.child.to_s
        @region_arr << [region_id, name]
      end
    end
  end
  
  def trigger
    @prefecture_id = params[:prefecture_id]
    @region_id = params[:region_id]
    @message = ""
    @supplement = ""
    url = "http://weather.yahoo.co.jp/weather/jp/past/#{@prefecture_id}/#{@region_id}.html"
    
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    max_tem_arr = []
    min_tem_arr = []

    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc.xpath('//small').each do |node|
      node.children.each do |data|
        if data.to_s.include?("#ff3300")
          max_tem_arr << data.content.to_i
        end
        if data.to_s.include?("#0066ff")
          min_tem_arr << data.content.to_i
        end
      end
    end
    max_tem_arr.reverse!
    min_tem_arr.reverse!
    # 解析
    @message = Message.create_message(max_tem_arr[0], max_tem_arr[1..4].sum/3.0, min_tem_arr[0], min_tem_arr[1..4].sum/3.0)

    @region = doc.title.sub("の過去の天気 - Yahoo!天気・災害", "")

    @doc = doc
  end
end
