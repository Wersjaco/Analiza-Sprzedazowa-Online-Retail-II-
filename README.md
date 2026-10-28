# Założenia:

Plik Csv z danymi został importowany do wcześniej stworzonej w pgAdminie tabelki 'Retail'.

W zapytaniach gdzie potrzebna była informacja o ilości poszczególnych zamówień usuwam wyniki które pochodzą z pojedynczych przypadków, robię tak żeby uniknąć zniekształcenia przez jednorazowe duże zakupy.

W przypadkach zamówień które posiadały wiersze gdzie kolumna 'Ilość' posiadała ujemne wyniki założyłem, że skoro część zamówienia została zwrócona, wykluczam całe zamówienie z analizy sprzedaży

# Dashboard
<img width="1320" height="806" alt="dashboard" src="https://github.com/user-attachments/assets/78719b8e-471c-4c8c-93fe-9ddf45db00e4" />
# Wnioski
* Panuje szablon gdzie na przestrzeni zimy firma odnotowuje ponad 20% spadki przychodu, zalecana jest zmiana ofert sezonowych lub wprowadzenie ofert promocyjnych w tym czasie.
* Większość przychodów firmy pochodzi z Wielkiej Brytanii (Suma przychodów z UK jest większa niż suma przychodów wszystkich pozostałych krajów).
* Irlandia generuje nieproporcjonalnie niski przychód względem wielkości rynku brytyjskiego, mimo geograficznej bliskości. Warto zbadać, czy to efekt niższej świadomości marki, czy braku lokalnej promocji.
* Połowa produktów z listy produktów z najmniejszym średnim przychodem na zamówienie to kartki upominkowe. Warto zastanowić się nad opcją kupna kartek jedynie w fizycznych placówkach, ponieważ zdalne kupowanie ich może być nieopłacalne dla firmy.
* Jest dużo klientów co złożyło ponad 50 zamówień. Warto próbować osiągnąć z nimi stałe relacje i proponować im dołączenie do programu lojalnościowego.

