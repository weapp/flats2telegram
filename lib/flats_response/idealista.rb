module FlatsResponse
  class Idealista < Foxy::HtmlResponse
    def url
      "http://www.idealista.com"
    end

    def flats
      foxy.search(cls: "item-info-container").map { |f|
        {
          # t: f.joinedtexts,
          id: f.find(cls: "item-link").attr("href").scan(%r{\d+}).first,
          title: f.find(cls: "item-link").joinedtexts,
          desc: f.find(cls: "item-description") && f.find(cls: "item-description").joinedtexts,
          href: "#{url}#{f.find(cls: "item-link").attr("href")}",
          details: (f.search(cls: "item-price") + f.search(cls: "item-detail")).map{|det| det.joinedtexts }.join(" | "),
          phones: f.search(cls: "icon-phone").map{|det| det.joinedtexts.gsub(" ", "") }.uniq.join(" | "),
          md: true
        }
      }
    end
  end
end
