# Założenia:

Plik Csv z danymi został importowany do wcześniej stworzonej w pgAdminie tabelki 'Retail'.

W zapytaniach gdzie potrzebna była informacja o ilości poszczególnych zamówień usuwam wyniki które pochodzą z pojedynczych przypadków, robię tak żeby uniknąć zniekształcenia przez jednorazowe duże zakupy.

W przypadkach zamówień które posiadały wiersze gdzie kolumna 'Ilość' posiadała ujemne wyniki założyłem, że skoro część zamówienia została zwrócona, wykluczam całe zamówienie z analizy sprzedaży
