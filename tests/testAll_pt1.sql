---MSH ve MH leri oluştur
DECLARE
    v_UrunAdetListesi SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('36:10', '24:5', '29:400');
    v_MagazaID NUMBER := 5;
    v_IslemTur NUMBER := 1;
BEGIN
    MagazaHareketEkle(v_UrunAdetListesi, v_MagazaID, v_IslemTur);
END;
/

--Kayıtlara bakmak için
    select a.IslemTur, b.*,c.UrunAdi from MagazaStokHareketleri a join MagazaHareketleri b on a.StokHareketID=b.HareketID join Urun c on b.UrunID=c.UrunID;


--MagazaUrunleri
    select c.MagazaAD as Mağaza_Adı ,UrunAdi,a.StokMiktari from MagazaUrunleri a join Urun b on a.UrunID=b.UrunID join Magaza c on a.MagazaID=c.MagazaID;


-------------------------------------------------AnaDepoMagazaTransferEkle Test----------------------------------------------------
DECLARE
    v_UrunAdetListesi SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('36:10', '24:500', '29:400');
    v_MagazaID NUMBER := 5;
    v_IslemTur NUMBER := 1;

BEGIN
 AnaDepoMagazaTransferEkle(v_MagazaID, v_IslemTur, v_UrunAdetListesi);
END;
/
    
select a.StokMiktari,b.MagazaAd,c.UrunAdi from MagazaUrunleri a join Magaza b on a.MagazaID=b.MagazaID join Urun c on a.UrunID= c.UrunID;
select a.stokMiktari,c.UrunAdi from AnaDepoUrunleri a join Urun c on a.UrunID= c.UrunID;

---------------------------------------------------------------------------son prosedür testi------------------------------------------------
BEGIN
    MagazaOlmayanUrunleriListele();
END;
/

--------------------------------------------------------------------------Diğer SELECT sorguları-------------------------------------------
select   * froM Urun;