INSERT INTO Tedarikci (TedarikciID, TedarikciAdi, Ulke, Eposta)
VALUES (TedarikciIDSeq.NEXTVAL, 'Tedarikci1', 'TedarikciUlke1', 'tedarikci1@example.com');

INSERT INTO Marka (MarkaID, MarkaAdi, Ulke, KurulusYili)
VALUES (MarkaIDSeq.NEXTVAL, 'Nike', 'ABD', 1964);

INSERT INTO Kategori (KategoriID, KategoriAdi)
VALUES (KategoriIDSeq.NEXTVAL, 'Ayakkabı');

INSERT INTO Urun (UrunID, UrunAdi, KategoriID, MarkaID, Fiyat)
VALUES (UrunIDSeq.NEXTVAL, 'Air Max', 1, 1, 200);

INSERT INTO Urun (UrunID, UrunAdi, KategoriID, MarkaID, Fiyat)
values
  (UrunIDSeq.NEXTVAL, 'Ürün3', 1, 1, 120);

INSERT INTO AnaDepoUrunleri (UrunID, StokMiktari)
VALUES (1, 50);

INSERT INTO Magaza (MagazaAd, Adres, Eposta) 
VALUES ('Karmark Kızılay', 'Ankara Caddesi No:12, Kızılay, Ankara', 'karmarkmoda@example.com');
INSERT INTO Magaza (MagazaAd, Adres, Eposta) 
VALUES ('Karmark Eryaman', 'Ankara Caddesi No:24, Eryaman, Ankara', 'karmarktech@example.com');
INSERT INTO Magaza (MagazaAd, Adres, Eposta) 
VALUES ('Karmark Kocatepe', 'Kocatepe Sokak No:7, Kızılay, Ankara', 'karmarkelektronik@example.com');
INSERT INTO Magaza (MagazaAd, Adres, Eposta) 
VALUES ('Karmark Sincan', 'Atatürk Bulvarı No:45, Sincan, Ankara', 'karmarkspor@example.com');
INSERT INTO Magaza (MagazaAd, Adres, Eposta) 
VALUES ('Karmark Yenimahalle', 'Müze Caddesi No:3, Yenimahalle, Ankara', 'karmarkgourmet@example.com');