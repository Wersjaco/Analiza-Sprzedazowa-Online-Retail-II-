--Usuwam zwrócone zamówienia
delete from "Retail"
where "Id_Transakcji" in (select distinct "Id_Transakcji" from "Retail" where "Ilosc" < 0)

-- usuwam wiersze z nullami w "Id_Klienta"

delete from "Retail"
where "Id_Klienta" is null


-- Top 10 przedmiotow przynoszących najwiekszy profit na zamowienie

create view "10_Przedmiotow_Najwiekszy_Przychod" 
as (

with "Cena_Razem" as (
        select  "Numer_Produktu",sum("Cena_Jednostkowa" * "Ilosc") as "suma"
        from "Retail"
		group by "Numer_Produktu"
		),
"Ilosc_Wystapien" as (
                 select  "Numer_Produktu",count(distinct "Id_Transakcji") as "ile"
                 from "Retail"
		         group by "Numer_Produktu"
               )
select distinct cr."Numer_Produktu","Opis", round("suma" / "ile",2) as "srednia_cena_produkutu_na_zamowienie",ile
from "Cena_Razem" cr join "Ilosc_Wystapien" iw on cr."Numer_Produktu"=iw."Numer_Produktu" join
     "Retail" r on cr."Numer_Produktu"=r."Numer_Produktu"
where ile > 1
order by "srednia_cena_produkutu_na_zamowienie" desc
fetch first 10 rows with ties

)

-- Top 10 przedmiotow przynoszących najmniejszy profit na zamowienie

create view "10_Przedmiotow_Najmniejszy_Przychod" 
as (

with "Cena_Razem" as (
        select  "Numer_Produktu",sum("Cena_Jednostkowa" * "Ilosc") as "suma"
        from "Retail"
		group by "Numer_Produktu"
		),
"Ilosc_Wystapien" as (
                 select  "Numer_Produktu",count(distinct "Id_Transakcji") as "ile"
                 from "Retail"
		         group by "Numer_Produktu"
               )
select distinct cr."Numer_Produktu","Opis", round("suma" / "ile",2) as "srednia_cena_produkutu_na_zamowienie",ile
  from "Cena_Razem" cr join "Ilosc_Wystapien" iw on cr."Numer_Produktu"=iw."Numer_Produktu" join
        "Retail" r on cr."Numer_Produktu"=r."Numer_Produktu"
  where ile > 1 and round("suma" / "ile",2) > 0
  order by "srednia_cena_produkutu_na_zamowienie" asc
  fetch first 10 rows with ties
)

--Top 10 najczesciej kupowanych przedmiotow

create view "10_Przedmiotow_Najczesciej_Kupowane" 
as (

with "pomocna" as (
select  "Numer_Produktu","Opis",count(distinct "Id_Transakcji") as "ile"
        from "Retail"
		group by "Numer_Produktu","Opis"
        order by ile desc
		),
"ranking" as (
    select *, dense_rank() over (order by ile desc) as "ranga" from pomocna
             )
select * from ranking where ranga <= 10
)

-- Przychod wg kraju

create view "Przychod_Wg_Kraju" 
as (
        select  "Kraj",sum("Cena_Jednostkowa" * "Ilosc") as "przychod"
        from "Retail"
		group by "Kraj"
		order by przychod desc
	)

-- Przychod miesiaca do miesiaca

create view "Przychod_Miesiac_Do_Miesiaca" 
as
(
with "przychody_miesiace" as (
select  date_part('year', "Data_Transakcji") as "Rok",
        date_part('month',"Data_Transakcji") as "Miesiac_Cyfra",
        TO_CHAR("Data_Transakcji",'Month') as "Miesiac_Nazwa",
		sum("Cena_Jednostkowa" * "Ilosc") as "przychod"
        from "Retail"
		group by "Rok","Miesiac_Cyfra","Miesiac_Nazwa"
        ),
	"lag" as (
        select *,
		lag(przychod,1) over ( order by "Rok","Miesiac_Cyfra" asc) as "przychod_ostatni_miesiac"
		from przychody_miesiace )
		
select "Rok","Miesiac_Nazwa",przychod,
      coalesce( round( ( (przychod-przychod_ostatni_miesiac) / przychod_ostatni_miesiac ) * 100, 2)::varchar,'Brak Danych' ) as "procentowy_stosunek_przychodu"
from lag
)

-- Klienci wedlug sumy i liczby sprzedazy

create view "Klienci_Suma_Liczba_Sprzedazy" as (

select  "Id_Klienta", sum("Cena_Jednostkowa" * "Ilosc") as "suma_sprzedazy", count(distinct "Id_Transakcji") as "ile_zamowien"
        from "Retail"
		group by "Id_Klienta"
		order by suma_sprzedazy desc

)
-- Klienci co płacą średnio najwięcej co zamówienie

create view "Srednia_Platnosci_Klientow" as (

with "pomocne" as (
select  "Id_Klienta", sum("Cena_Jednostkowa" * "Ilosc") as "suma_sprzedazy", count(distinct "Id_Transakcji") as "ile_zamowien"
        from "Retail"
		group by "Id_Klienta"
		order by suma_sprzedazy desc
		)
select *, round(suma_sprzedazy/ile_zamowien,2) as "srednia_na_zamowienie"
from pomocne
where ile_zamowien > 1
order by srednia_na_zamowienie desc
)
-- W jakie dni kupowali poszczegolni klienci?

create view "Dni_Transakcji_Klientow" as (

select "Id_Klienta",
To_Char("Data_Transakcji",'Day') as "dzien_tygodnia_nazwa" ,
count(distinct "Id_Transakcji") as "ile"
from "Retail"
group by "Id_Klienta","dzien_tygodnia_nazwa",EXTRACT(ISODOW FROM "Data_Transakcji")
order by "Id_Klienta",EXTRACT(ISODOW FROM "Data_Transakcji") asc
)


--które produkty sprzedają się najbardziej ilościowo, średnio na jedno zamówienie?

create view "Ilosc_Sztuk_Srednio_Na_Zamowienie" as (

select distinct "Numer_Produktu",
round(avg("Ilosc") over (partition by "Numer_Produktu"),1) as "srednia_ilosci"
from "Retail"
order by "srednia_ilosci" desc
)

--Który kraj płaci średnio najdroższe zamówienia?

create view "Srednia_Kwota_Zamowienia_Kraj" as (

with "pomocne" as (
        select  "Id_Transakcji","Kraj", Sum("Cena_Jednostkowa" * "Ilosc") as "suma_za_zamowienie"
        from "Retail"
		group by "Id_Transakcji","Kraj"
		)
select "Kraj", round(avg(suma_za_zamowienie),2) as "srednia_kwota_za_zamowienie"
from pomocne
group by "Kraj"
order by avg(suma_za_zamowienie) desc

)
