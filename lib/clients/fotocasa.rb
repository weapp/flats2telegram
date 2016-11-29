module Clients
  class Fotocasa < Foxy::Client
    def url
      "http://www.fotocasa.es/"
    end

    def rate_limit
      3.0/1
    end



    def flats
      (f1 + f2).uniq
    end

    def f1
      eraw(path: "alquiler/casas/madrid-capital/chamberi/listado-por-foto?crp=1&ts=chamber%C3%AD&llm=724,14,28,173,0,28079,0,177,0&minp=0&maxp=1000&f=publicationdate&o=desc&opi=36&ftg=false&pgg=false&odg=false&fav=false&grad=false&fss=true&mode=1&cu=es-es&pbti=2&nhtti=3&craap=1&fss=true&fs=false",
           class: FotoFlats).flats
    end

    def f2
      eraw(path: "alquiler/casas/madrid-capital/listado-por-foto?crp=1&llm=724,14,28,173,0,28079,0,672,50;724,14,28,173,0,28079,0,177,139;724,14,28,173,0,28079,0,177,138;724,14,28,173,0,28079,0,177,140;724,14,28,173,0,28079,0,177,142;724,14,28,173,0,28079,0,177,141;724,14,28,173,0,28079,0,177,137;724,14,28,173,0,28079,0,672,46&maxp=1000&mins=30&minr=1&f=publicationdate&o=desc&opi=36&ftg=false&pgg=false&odg=false&fav=false&grad=false&fss=true&mode=1&cu=es-es&nhtti=3&craap=1&fss=true",
           class: FotoFlats).flats
    end
  end
end

class FotoFlats < Foxy::HtmlResponse

  def flats
    foxy.search(cls: "property-card").map { |f|
      {
        # t: f.joinedtexts,
        id: f.find(cls: "property-location").attr("href").scan(%r{/[^/]*\?}).first[1...-1],
        title: f.find(cls: "property-location").joinedtexts,
        desc: f.find(cls: "price-container") && f.find(cls: "price-container").joinedtexts,
        href: "#{f.find(cls: "property-location").attr("href")}",
        # details: f.search(cls: "item-detail").map{|det| det.joinedtexts }.join(" | "),
        # phones: f.search(cls: "property-card_phone").map{|det| det.joinedtexts.gsub(" ", "") }.uniq.join(" | "),
        md: true,
      }
    }
  end
end
