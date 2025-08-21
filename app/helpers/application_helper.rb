module ApplicationHelper
  
def icon_image_for(user, size: 40, html: {})
  html = { alt: 'icon', class: [html[:class], 'avatar-img'].compact.join(' ') }
  if user&.icon_image&.attached?
    image_tag user.icon_image, **html
  else
    image_tag 'default-icon.png', **html
  end
end

  def ymd(date)
    date&.strftime('%Y/%m/%d')
  end

  def ymd_hm(time)
    time&.strftime('%Y/%m/%d %H:%M')
  end
  def yen(n)
    "¥#{number_with_delimiter(n)}"
  end

  def facility_image_for(room, size: 150, **html)
    if room&.facility_image&.attached?
      image_tag room.facility_image.variant(resize_to_limit: [size, size]), **html
    else
      begin
        image_tag 'default-facility.jpg', { size: "#{size}x#{size}" }.merge(html)
      rescue Sprockets::Rails::Helper::AssetNotFound
        begin
          image_tag 'default-facility.png', { size: "#{size}x#{size}" }.merge(html)
        rescue Sprockets::Rails::Helper::AssetNotFound
          image_tag 'default-icon.png', { size: "#{size}x#{size}" }.merge(html)
        end
      end
    end
  end
end
