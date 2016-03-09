require 'open-uri'
require 'nokogiri'
require 'sqlite3'

db = SQLite3::Database.new 'test.sqlite3'
 # スクレイピング先のURL
for num in 0..89
  url = 'http://ad-navi.sendenkaigi.com/actor_company/index/' + (num*25).to_s

  charset = nil
  html = open(url) do |f|
    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end

  # htmlをパース(解析)してオブジェクトを作成
  doc = Nokogiri::HTML.parse(html, nil, charset)

  doc.xpath('//div[@class="corp_data2"]').each do |node|
    if(node.css('dl[4]/dd').inner_text.match(/.*イベント.*/).to_s != "")

      kaisha = node.css('p[1]').inner_text

      ninzu = node.css('p.right.nomal').inner_text.match(/[0-9]+人/).to_s.to_i

      basho = node.css('dl[3]/dd').inner_text

      shurui = node.css('dl[4]/dd').inner_text.match(/.*イベント.*/).to_s.gsub(/\t/, "")

      db.execute("insert into a ( KAISHA, NINZU, BASHO, SHURUI) values('#{kaisha}', '#{ninzu}', '#{basho}', '#{shurui}')")

    end
  end
end
