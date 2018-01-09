module FlatsResponse
  class Fotocasa < Foxy::HtmlResponse
    def flats
      foxy.search(cls: "re-Card-secondary").map { |f|
        {
          # t: f.joinedtexts,
          id: f.find(cls: "re-Card-link").attr("href").scan(%r{/[^/]*\?}).first[1...-1],
          title: f.find(cls: "re-Card-title").joinedtexts,
          desc: f.search(cls: "re-Card-description").joinedtexts,
          href: "http://www.fotocasa.es#{f.find(cls: "re-Card-link").attr("href")}",
          details: (f.search(cls: "re-Card-price") + f.search(cls: "re-Card-feature")).map{|det| det.joinedtexts }.join(" | "),
          phones: f.search(cls: "re-Card-contactButton--phone").joinedtexts,
          md: true,
        }
      }
    end
  end
end
