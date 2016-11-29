module Clients
  class Idealista < Foxy::Client
    def url
      "https://www.idealista.com/"
    end

    def rate_limit
      3.0/1
    end

    def flats
      (f1 + f2).uniq
    end

    def f1
      # eraw(path: "areas/alquiler-viviendas/con-precio-hasta_1000,exterior,ultimas-plantas,plantas-intermedias/?shape=%28%28ggxuFbbuU%7BR%3FkCImJy%40aF_BiFeCeB_BmEmD%7DAiBqC_EoDsEqCoCmB%7BBs%40kAq%40wA%5DuAwAiH%7DA_KiAmGM%7BB%3FiTFeC%3FyFLyFL%7DB%3FyIgDlJT%7BB~AcDbCsEfAuAnAiBdBsBfB_B%7CD_ElBkArBcAnIkDtBcA~FiB%60Ce%40tBo%40~Fy%40hC%5BxCI~Y%3F%60IRlDFtGx%40zBf%40xF~ArBv%40fBlAtAd%40%60An%40vAd%40pC~A%7CB~Ap%40n%40dBbA%60AbATd%40tBdCZRj%40%60AzBrBpAzBj%40x%40b%40bAj%40n%40r%40jAD%5C%3FtGMhEMrBUpB%5DrBy%40bGe%40dFUnI%5BbGaA~GuBdIy%40dCeBrHmBnFy%40~AwA~AwDbDoAx%40gDtAqFhBeBZkEbAmBn%40mBZmBf%40wIfBwFx%40wFf%40%29%29",
      # eraw(path: "areas/alquiler-viviendas/con-precio-hasta_1000,exterior,ultimas-plantas,plantas-intermedias/?shape=%28%28ggxuFbbuU%7BR%3FkCImJy%40aF_BiFeCeB_BmEmD%7DAiBqC_EoDsEqCoCmB%7BBs%40kAq%40wA%5DuAwAiH%7DA_KiAmGM%7BB%3FiTFeC%3FyFLyFL%7DB%3FyIgDlJT%7BB%7EAcDbCsEfAuAnAiBdBsBfB_B%7CD_ElBkArBcAnIkDtBcA%7EFiB%60Ce%40tBo%40%7EFy%40hC%5BxCI%7EY%3F%60IRlDFtGx%40zBf%40xF%7EArBv%40fBlAtAd%40%60An%40vAd%40pC%7EA%7CB%7EAp%40n%40dBbA%60AbATd%40tBdCZRj%40%60AzBrBpAzBj%40x%40b%40bAj%40n%40r%40jAD%5C%3FtGMhEMrBUpB%5DrBy%40bGe%40dFUnI%5BbGaA%7EGuBdIy%40dCeBrHmBnFy%40%7EAwA%7EAwDbDoAx%40gDtAqFhBeBZkEbAmBn%40mBZmBf%40wIfBwFx%40wFf%40%29%29&ordenado-por=precio-asc",
      # eraw(path: "areas/alquiler-viviendas/con-precio-hasta_1000,exterior,ultimas-plantas,plantas-intermedias/?shape=%28%28ggxuFbbuU%7BR%3FkCImJy%40aF_BiFeCeB_BmEmD%7DAiBqC_EoDsEqCoCmB%7BBs%40kAq%40wA%5DuAwAiH%7DA_KiAmGM%7BB%3FiTFeC%3FyFLyFL%7DB%3FyIgDlJT%7BB%7EAcDbCsEfAuAnAiBdBsBfB_B%7CD_ElBkArBcAnIkDtBcA%7EFiB%60Ce%40tBo%40%7EFy%40hC%5BxCI%7EY%3F%60IRlDFtGx%40zBf%40xF%7EArBv%40fBlAtAd%40%60An%40vAd%40pC%7EA%7CB%7EAp%40n%40dBbA%60AbATd%40tBdCZRj%40%60AzBrBpAzBj%40x%40b%40bAj%40n%40r%40jAD%5C%3FtGMhEMrBUpB%5DrBy%40bGe%40dFUnI%5BbGaA%7EGuBdIy%40dCeBrHmBnFy%40%7EAwA%7EAwDbDoAx%40gDtAqFhBeBZkEbAmBn%40mBZmBf%40wIfBwFx%40wFf%40%29%29&ordenado-por=fecha-publicacion-desc",
      eraw(path: "areas/alquiler-viviendas/con-precio-hasta_1000,exterior,ultimas-plantas,plantas-intermedias/?shape=%28%28_nwuFprsUeaAuAcYaNwF_Gcd%40%7BKxA%7BtAdqBUd%5DrGzg%40zK%60LfQePj_Awm%40%60T%29%29&ordenado-por=fecha-publicacion-desc",
           class: Flats).flats
    end

    def f2
      eraw(path: "alquiler-viviendas/madrid/chamberi/con-precio-hasta_1000,metros-cuadrados-mas-de_40,de-un-dormitorio,de-dos-dormitorios,de-tres-dormitorios,de-cuatro-cinco-habitaciones-o-mas,exterior,ultimas-plantas,plantas-intermedias/?ordenado-por=fecha-publicacion-desc",
           class: Flats).flats
    end
  end
end

class Flats < Foxy::HtmlResponse
  def url
    "https://www.idealista.com"
  end

  def flats
    foxy.search(cls: "item-info-container").map { |f|
      {
        # t: f.joinedtexts,
        id: f.find(cls: "item-link").attr("href").scan(%r{\d+}).first,
        title: f.find(cls: "item-link").joinedtexts,
        desc: f.find(cls: "item-description") && f.find(cls: "item-description").joinedtexts,
        href: "#{url}#{f.find(cls: "item-link").attr("href")}",
        details: f.search(cls: "item-detail").map{|det| det.joinedtexts }.join(" | "),
        phones: f.search(cls: "icon-phone").map{|det| det.joinedtexts.gsub(" ", "") }.uniq.join(" | "),
        md: true
      }
    }
  end
end


    # def eraw(options)
    #   cacheopts = options.delete(:cache)
    #   klass = options.delete(:class) || Foxy::HtmlResponse
    #   response_options = options.merge(options.delete(:response_params) || {})
    #   klass.new(raw_with_cache(options, cacheopts), response_options)
    # end


# curl 'https://www.idealista.com/areas/alquiler-viviendas/con-precio-hasta_1000,exterior,ultimas-plantas,plantas-intermedias/?shape=%28%28ggxuFbbuU%7BR%3FkCImJy%40aF_BiFeCeB_BmEmD%7DAiBqC_EoDsEqCoCmB%7BBs%40kAq%40wA%5DuAwAiH%7DA_KiAmGM%7BB%3FiTFeC%3FyFLyFL%7DB%3FyIgDlJT%7BB%7EAcDbCsEfAuAnAiBdBsBfB_B%7CD_ElBkArBcAnIkDtBcA%7EFiB%60Ce%40tBo%40%7EFy%40hC%5BxCI%7EY%3F%60IRlDFtGx%40zBf%40xF%7EArBv%40fBlAtAd%40%60An%40vAd%40pC%7EA%7CB%7EAp%40n%40dBbA%60AbATd%40tBdCZRj%40%60AzBrBpAzBj%40x%40b%40bAj%40n%40r%40jAD%5C%3FtGMhEMrBUpB%5DrBy%40bGe%40dFUnI%5BbGaA%7EGuBdIy%40dCeBrHmBnFy%40%7EAwA%7EAwDbDoAx%40gDtAqFhBeBZkEbAmBn%40mBZmBf%40wIfBwFx%40wFf%40%29%29'
# -H 'Accept-Encoding: gzip, deflate, sdch, br'
# -H 'Accept-Language: es,en;q=0.8'
# -H 'Upgrade-Insecure-Requests: 1'
# -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36'
# -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
# -H 'Cache-Control: max-age=0'
# -H $'Cookie: gsScrollPos=; userUUID=3c5cff7f-89b9-4a76-9b94-0cee3f0a9ac4; xtvrn=$352991$; cookieDirectiveClosed=true; TestIfCookieP=ok; pbw=%24b%3d16530%3b%24o%3d12100%3b%24sh%3d768%3b%24sw%3d1280; news_test_ab=b; _cb_ls=1; pid=8397630079325201434; pdomid=26; vs=33114=7269738&34507=7267512; SESSe5d93df3d31475f80c30f68dc304624d=OMhm26k69Hkyg5SDiXqQ6YOdOD6_eesCWfop3o1EtgU; has_js=1; _cb=BWjLZwBcmDDMCfhTcX; _chartbeat2=.1477406063076.1478336337172.100100000011.DuYTvOCXUQwoD4G_-mBzNCbYCgiR-8; mo=m8bWP5IyJGmkRBsEaJjsNpaKN0Q0diqqTSZ+LYrFPniZQ7XxmIrlpAnovarNjqVi0zNPBpnKjrb8uHi0ZAvtP2ydhMJd2zVweGHR8G+WzJ0bkB3nzWZnMn5NiEqyJVpu; mortgagesCalculate=%7B%22propertyType%22%3A1%2C%22location%22%3A%220-EU-ES-28%22%2C%22housePrice%22%3A121600%2C%22taxRate%22%3A5%2C%22givenAmount%22%3A40000%2C%22years%22%3A15%2C%22simulationType%22%3A1%7D; gsScrollPos=; xtor352991=epr-201-%5Bexpress_alerts_20161108%5D-20161108-%5Binmueble%5D-%5B%5D-20161108141233; xtdate352991=410728.3630825; xtide=%5B%5D; askToSaveAlertPopUp=true; JSESSIONID=A1B30DFA1B97D3B56E508FC8B6232F38.web15; CASTGC=TGT-3742200-yvbJtHcLbTjd1nwtomdxXNNcYKAWpyufUNe7iIuWJ2RogkhpSV-cas; uc="g0pungVY+VRSo+BI6wDqTKOOELBqciWLppPrbEKh/DBI4YnsG8oA3/SwAnrtWMeFlI9ogKdrx3UkhOnf3xpr4Q=="; nl="jaxZX6CKYJz83uw1aJ1V/XSjB1VwWrEgi92RW0TDqP4="; ml="hx7kRaqCzC9cD4r/uB5ZQlZcK6L9KoPr+jJ3L6T/Fy4="; cc=eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0Nzg3OTIwNzEsImN0Ijo0MDEyNjk1fQ.lj2mdVLOIpX53-7I88PEWdkHJm0p-N-QqPiW4Pkdi6U; listingGalleryBoostEnabled=false; sendA1B30DFA1B97D3B56E508FC8B6232F38.web15="{\'friendsEmail\':null,\'email\':\'K1V5j0FP2Gu2QdQijnPDLYIH6l0+GaX9\',\'message\':null}"; cookieSearch-1="/areas/alquiler-viviendas/con-precio-hasta_1000,exterior,ultimas-plantas,plantas-intermedias/?shape=%28%28ggxuFbbuU%7BR%3FkCImJy%40aF_BiFeCeB_BmEmD%7DAiBqC_EoDsEqCoCmB%7BBs%40kAq%40wA%5DuAwAiH%7DA_KiAmGM%7BB%3FiTFeC%3FyFLyFL%7DB%3FyIgDlJT%7BB%7EAcDbCsEfAuAnAiBdBsBfB_B%7CD_ElBkArBcAnIkDtBcA%7EFiB%60Ce%40tBo%40%7EFy%40hC%5BxCI%7EY%3F%60IRlDFtGx%40zBf%40xF%7EArBv%40fBlAtAd%40%60An%40vAd%40pC%7EA%7CB%7EAp%40n%40dBbA%60AbATd%40tBdCZRj%40%60AzBrBpAzBj%40x%40b%40bAj%40n%40r%40jAD%5C%3FtGMhEMrBUpB%5DrBy%40bGe%40dFUnI%5BbGaA%7EGuBdIy%40dCeBrHmBnFy%40%7EAwA%7EAwDbDoAx%40gDtAqFhBeBZkEbAmBn%40mBZmBf%40wIfBwFx%40wFf%40%29%29:1478715866862"; contactA1B30DFA1B97D3B56E508FC8B6232F38.web15="{\'email\':\'K1V5j0FP2Gu2QdQijnPDLYIH6l0+GaX9\',\'phone\':null,\'phonePrefix\':null,\'friendEmails\':null,\'name\':\'NyDhh3Hbkpo=\',\'message\':null,\'message2Friends\':null,\'maxNumberContactsAllow\':10,\'defaultMessage\':true}"; WEBSERVERID=O|WCNp+|WCNCI; xtan352991=null-111898096; xtant352991=1'
# -H 'Connection: keep-alive' --compressed
