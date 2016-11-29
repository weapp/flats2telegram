module Clients
  class EnAlquiler < Foxy::Client
    def url
      "http://www.enalquiler.com/"
    end

    def rate_limit
      3.0/1
    end

    def flats
      eraw(path: "search?provincia=30&poblacion=27745&distritos=14,16,27&barrios=98,100,101,108,109,111,112,113,186&precio_max=1000&habitaciones=1&metros2=40&ascensor=1&exterior=1",
           class: EFlats).flats
    end
  end
end

class EFlats < Foxy::HtmlResponse
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

# curl 'http://www.enalquiler.com/search?provincia=30&poblacion=27745&distritos=14,16,27&barrios=98,100,101,108,109,111,112,113,186&precio_max=1000&habitaciones=1&metros2=40&ascensor=1&exterior=1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: es,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://www.enalquiler.com/search?provincia=30&poblacion=27745&distritos=14,16,27&barrios=98,100,101,108,109,111,112,113,186&precio_max=1000&metros2=40&ascensor=1&exterior=1' -H 'Cookie: __gads=ID=e41f1740e21634d0:T=1478284076:S=ALNI_Ma6uNVFu69CIqReaayQxU46-5oeww; gsScrollPos=; __utmt=1; _gat_UA-1006135-8=1; _pk_ref.2.5178=%5B%22%22%2C%22%22%2C1480181006%2C%22https%3A%2F%2Fwww.google.es%2F%22%5D; orderList=metros2%2Cexterior%2Cascensor; s_Enalquiler=external.....ref_ficha.....search_page.....search_params%261.....9.....1.....YToyMzp7czo5OiJwcm92aW5jaWEiO3M6MjoiMzAiO3M6OToicG9ibGFjaW9uIjtzOjU6IjI3NzQ1IjtzOjk6ImRpc3RyaXRvcyI7czo4OiIxNCwxNiwyNyI7czo3OiJiYXJyaW9zIjtzOjM0OiI5OCwxMDAsMTAxLDEwOCwxMDksMTExLDExMiwxMTMsMTg2IjtzOjEwOiJwcmVjaW9fbWF4IjtzOjQ6IjEwMDAiO3M6MTI6ImhhYml0YWNpb25lcyI7czoxOiIxIjtzOjc6Im1ldHJvczIiO3M6MjoiNDAiO3M6ODoiYXNjZW5zb3IiO3M6MToiMSI7czo4OiJleHRlcmlvciI7czoxOiIxIjtzOjI6ImxiIjtzOjA6IiI7czozMjoiZmtfaWRfdGJsX3BvYmxhY2lvbmVzX2Rlc3RhY2Fkb3MiO3M6MjoiMTAiO3M6NDoicGFnZSI7czoxOiIxIjtzOjc6InNpbl9yZXMiO3M6MDoiIjtzOjEyOiJxdWVyeV9zdHJpbmciO3M6MDoiIjtzOjM6InRwbCI7czowOiIiO3M6MzoibWlkIjtzOjA6IiI7czo1OiJtaWRnYyI7czowOiIiO3M6MTA6InJlc3BvbnNpdmUiO3M6MDoiIjtzOjExOiJvcmRlcl9maWVsZCI7czoxOiIwIjtzOjY6InJlZmNvZCI7czo3OiJzZWFyY2gyIjtzOjY6ImZvb3RlciI7czowOiIiO3M6MTQ6Im9ubGluZV9ib29raW5nIjtzOjA6IiI7czo1OiJsZWVkcyI7czozMTM6IiNzLDU2NDYyNCwwLDAsNDQyMTc1OCNzLDUxNzE0NiwwLDAsNDI3ODU3MiNzLDY3MzcyMSwwLDAsNDUzNjU2MCNzLDcxMTg2LDAsMCw0NTE4NjczI3MsNjYzNjQyLDAsMCw0NTE1MjY1I3MsNjM4MTgxLDU0NjQyNiwwLDQ0ODgwNTgjcyw2MTg4OTgsMCwwLDQ0MzcyODIjcywyMDU1NCwwLDAsNDQyNjk3MSNzLDM5NjgyMiwwLDAsNDM5MTA5OSNzLDM5MjUwNiwwLDAsNDUzMjYwMCNzLDU5MjYzMCwwLDAsNDQxMTIzNyNzLDU4NjYwNiwwLDAsNDM5NjI1NiNzLDU4NjYwNiwwLDAsNDM1NzY2NiNzLDU5Mzc3NiwwLDAsNDMxMjYxOCNhLDUyMTM0NTsxMDY2NDEiO30%3D; __utma=248875137.207224981.1478282603.1479583121.1480181004.14; __utmb=248875137.25.10.1480181004; __utmc=248875137; __utmz=248875137.1478510424.7.4.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); _ga=GA1.2.207224981.1478282603; _pk_id.2.5178=e30d2d7b1b295b20.1478282609.16.1480181301.1480181006.; _pk_ses.2.5178=*' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed
