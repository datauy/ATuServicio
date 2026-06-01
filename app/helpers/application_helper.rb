module ApplicationHelper
  def format_value(num, dtype)
    if num == nil || num == -1
      "<span class='no-data'>Sin dato</span>".html_safe
    else
      case dtype
      when 'percent'
        "#{number_with_delimiter(num, {delimiter: '.', separator: ','})} %"
      when 'boolean'
        if num == 0
          '<span class="percent cross">No</span>'.html_safe
        else
          '<span class="percent tick">Si</span>'.html_safe
        end
      when 'price'
        if num == 0
          '<span class="free">Gratis</span>'.html_safe
        else
          "$ #{number_with_delimiter(num, {delimiter: '.', separator: ','})}"
        end
      else
        number_with_delimiter(num, {delimiter: '.', separator: ','})
      end
    end 
  end

  def svg(file)
    path = "#{Rails.root}/public/images/#{file}"
    if File.exist?(path)
      File.read(path).html_safe
    else
      File.read("#{Rails.root}/public/images/time.svg").html_safe
    end
  end
end
