module PiaHelper

  def nested_pias(groups)
    if groups
      result = content_tag(:div) do
        groups.map do |pia, children|
          is_first = pia.ancestry.blank?
          is_content_empty = !pia.informacion && !pia.cie_9 && !pia.normativa &&
            !pia.normativa_url && children == {} ? 'true' : 'false'

          expanded = is_first ? 'in show' : '';
          angle_icon= is_first ? 'fa-angle-up' : 'fa-angle-down'

          link_icon = content_tag :i, class: "pias-link-icon fa #{angle_icon}" do "" end

          header = content_tag :div, class: 'card-header', id: "#{pia.pid}-title" do
            content_tag :h5, class: "mb-0" do
              content_tag :a,
                class: "pias-link",
                "data-toggle" => "collapse",
                href: "##{pia.pid}",
                "aria-expanded" =>(is_first ? "true" : "false"),
                "aria-controls" =>"#{pia.pid}" do
                ((content_tag :span, "#{pia.pid} - #{pia.titulo}") +
                  (if is_content_empty != 'true'
                     link_icon
                   end)
                ).html_safe
              end
            end
          end

          body =
            content_tag :div,
            id: "#{pia.pid}",
            class: "collapse #{expanded} #{ is_first ? 'root': '' }" do
            content_tag :div, class: "card-body nested_pia" do
              content_tag(:p, pia.informacion.to_s.html_safe, class: "pia-info") +
                (if pia.cie_9
                   content_tag(:p,"Codificación CIE 9: #{pia.cie_9}", class: "pia-cie9")
                 end)  +
                (if pia.normativa && pia.normativa_url
                   content_tag(:p,content_tag(:a, pia.normativa, href: "#{pia.normativa_url}", class: "pia-normativa" ))
                 end)  +
                (if children != {}
                   nested_pias(children)
                 end)

            end
          end

          card = content_tag :div, class: "card" do
            (header +
              (if is_content_empty === 'false'
                 body
               end)
            ).html_safe
          end
        end.join.html_safe
      end
    end

  end

end
