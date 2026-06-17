module ApplicationHelper
  def format_value(num, dtype, max_value = 0)
    if num == nil || num == -1
      "<span class='no-data'>Sin dato</span>".html_safe
    else
      case dtype
      when 'percent'
        "<div class='bar'><div class='total-bar'></div><div class='percent-bar' style='width: #{num.to_i}%'></div></div><span>#{number_with_delimiter(num.round(2), {delimiter: '.', separator: ','})} %</span>".html_safe
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
          if max_value > 0
            "<div class='bar price'><img src='/images/circle-dollar-negativo.svg'/><div class='percent-bar' style='width: #{num.to_i*100/max_value}%'></div></div><span class='price'>$ #{number_with_delimiter(num.round(2), {delimiter: '.', separator: ','})}</span>".html_safe
          else
            "<span class='price'>$ #{number_with_delimiter(num.round(2), {delimiter: '.', separator: ','})}</span>".html_safe
          end
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
