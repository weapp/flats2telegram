module FlatsResponse
  class Enalquiler < Foxy::HtmlResponse
    def flats
      foxy.search(cls: "property-info").map { |f|
        {
          # t: r(f.joinedtexts),
          id: r("EA-" + f.find(cls: "property-title").attr("href").scan(%r{\d\d\d+}).first),
          title: r(f.find(cls: "property-title-price-wrapper").joinedtexts),
          desc: r(f.find(cls: "property-description").joinedtexts),
          href: r(f.find(cls: "property-title").attr("href")),
          details: r(f.search(cls: "property-resume").map{|det| det.joinedtexts }.join(" | ")),
          phones: r("-"),
          md: false
        }
      }
    end

    def r(text)
      # text.encode("ISO-8859-2", "UTF-8", invalid: :replace, undef: :replace)
      # text.encode("MacCyrillic", "UTF-8", invalid: :replace, undef: :replace)
      # Iconv.conv("UTF8", "MacCyrillic", text)
      Iconv.conv("UTF8", "ISO-8859-2", text)
      # text
      # text.gsub(/[^a-zA-Z0-9\_\ \:\,\/\\\(\)\.\-]/, '?')
    end
  end
end