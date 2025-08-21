IMAGES_PATH = Rails.root.join('db', 'seeds', 'images')

puts "\n==> Seeding demo user"
user = UserModel.find_or_create_by!(email: 'demo@example.com') do |u|
  u.name = 'Demo'
  u.password = 'password'
end
puts "  user: #{user.email} (id=#{user.id})"

# Define the hotels FIRST so we can reference them later
hotels = [
  {
    title: 'アパホテル＆リゾート〈両国駅タワー〉',
    description: 'NTTドコモ歴史展示スクエアから徒歩2分のアパホテル＆リゾート〈両国駅タワー〉は東京にある宿泊施設で、フィットネスセンター、専用駐車場、庭、レストランを提供しています。3つ星のホテルで、24時間対応のフロントと荷物預かりを提供しています。このホテルから両国国技館まで徒歩4分、Yokoamicho Parkまで400mです。',
    fee: 12_096,
    address: '東京都墨田区横網1丁目11-10',
    image: 'apa-hotel.jpg'
  },
  {
    title: 'Tokyu Stay Yotsuya - Shinjuku Area',
    description: '東急ステイ四谷は、JR四谷駅から徒歩3分の便利な立地にあり、設備の整った宿泊施設（簡易キッチン付）を提供しています。館内全域で無料WiFiを利用できます。',
    fee: 31_860,
    address: 'Tokyo, Shinjuku-ku Yotsuya 2-1',
    image: 'tokyu-stay.jpg'
  },
  {
    title: 'THE LIVELY 大阪本町',
    description: '大阪市にあるTHE LIVELY 大阪本町は、エアコン付きのお部屋、共用ラウンジ、無料WiFi、テラスを提供しています。バーを提供するホテルで、そばにはいくつかの有名観光スポットがあり、Stage Kuまで約徒歩7分、Nanba Betsuin Templeまで約1km、Namba Shrineまで約徒歩13分です。',
    fee: 27_855,
    address: '大阪府, 大阪市, 中央区南本町1-5-11',
    image: 'the-lively.jpg'
  },
  {
    title: 'ホテルオークラ京都 岡崎別邸',
    description: '永観堂禅林寺から1km以内のホテルオークラ京都 岡崎別邸は京都市にある宿泊施設で、フィットネスセンター、専用駐車場、庭、レストランを提供しています。5つ星のホテルで、ルームサービス、24時間対応のフロント、無料WiFiを提供しています。バーではカクテルを楽しめます。',
    fee: 48_000,
    address: '京都府, 京都市, 左京区岡崎天王町26-6',
    image: 'okura-kyoto.jpg'
  },
  {
    title: '札幌プリンスホテル',
    description: '設備の整った専用バスルーム（シャワー、ビデ、ヘアドライヤー、スリッパ付）があるファミリールームです。防音壁のファミリールームで、エアコン、薄型ケーブルテレビ、専用エントランス、お茶 / コーヒーが備わります。市街の景色を望めます。ベッド2台付きのユニットです。',
    fee: 20_671,
    address: '北海道, 札幌市, 中央区南2条西11丁目',
    image: nil
  }
]

puts "\n==> Cleaning old hotels"
titles_to_keep = hotels.map { |h| h[:title] }
user.room_models.where.not(title: titles_to_keep).destroy_all

puts "\n==> Seeding demo hotels (sync/idempotent)"
hotels.each do |h|
  room = user.room_models.find_or_initialize_by(title: h[:title])
  room.description = h[:description]
  room.fee = h[:fee]
  room.address = h[:address]
  room.save!
  puts "  saved: #{room.title} (id=#{room.id})"

  if h[:image].present?
    img_path = IMAGES_PATH.join(h[:image])
    if File.exist?(img_path)
      unless room.facility_image.attached?
        room.facility_image.attach(
          io: File.open(img_path),
          filename: h[:image],
          content_type: 'image/jpeg'
        )
        puts "  attached: #{h[:image]} => #{room.title}"
      end
    else
      puts "  (画像なし) #{h[:image]} - 添付をスキップ"
    end
  end
end

puts "\n==> Done. Rooms: #{user.room_models.count}"
