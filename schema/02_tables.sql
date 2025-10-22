CREATE TABLE Tedarikci (
    TedarikciID NUMBER DEFAULT TedarikciIDSeq.NEXTVAL PRIMARY KEY,
    TedarikciAdi VARCHAR2(50) NOT NULL,
    Ulke VARCHAR2(50),
    Eposta VARCHAR2(100)
);

CREATE TABLE Marka (
    MarkaID NUMBER DEFAULT MarkaIDSeq.NEXTVAL PRIMARY KEY,
    MarkaAdi VARCHAR2(50) NOT NULL,
    Ulke VARCHAR2(50),
    KurulusYili NUMBER
);

CREATE TABLE Kategori (
    KategoriID NUMBER DEFAULT KategoriIDSeq.NEXTVAL PRIMARY KEY,
    KategoriAdi VARCHAR2(50) NOT NULL
);

CREATE TABLE Urun (
    UrunID NUMBER DEFAULT UrunIDSeq.NEXTVAL PRIMARY KEY,
    UrunAdi VARCHAR2(100) NOT NULL,
    KategoriID NUMBER,
    MarkaID NUMBER,
    Fiyat NUMBER,
    FOREIGN KEY (KategoriID) REFERENCES Kategori(KategoriID),
    FOREIGN KEY (MarkaID) REFERENCES Marka(MarkaID)
);

CREATE TABLE Magaza (
    MagazaID NUMBER DEFAULT MagazaIDSeq.NEXTVAL PRIMARY KEY,
    MagazaAd VARCHAR2(80) NOT NULL,
    Adres VARCHAR2(200),
    Eposta VARCHAR2(100)
);

CREATE TABLE MagazaUrunleri (
    MagazaID NUMBER,
    UrunID NUMBER,
    StokMiktari NUMBER,
    PRIMARY KEY (MagazaID, UrunID),
    FOREIGN KEY (MagazaID) REFERENCES Magaza(MagazaID),
    FOREIGN KEY (UrunID) REFERENCES Urun(UrunID)
);

CREATE TABLE AnaDepoUrunleri (
    UrunID NUMBER PRIMARY KEY,
    StokMiktari NUMBER,
    FOREIGN KEY (UrunID) REFERENCES Urun(UrunID)
);

CREATE TABLE AnaDepoMagazaTransferleri (
    TransferID NUMBER DEFAULT TransferIDSeq.NEXTVAL PRIMARY KEY,
    TedarikciID number,
    MagazaID NUMBER,
    TransferTarihi DATE,
    IslemTur NUMBER(1),
    FOREIGN KEY (MagazaID) REFERENCES Magaza(MagazaID),
    FOREIGN KEY (TedarikciID) REFERENCES Tedarikci(TedarikciID)

);

CREATE TABLE TransferUrunleri (
    TransferID NUMBER,
    UrunID NUMBER,
    Adet Number,
    FOREIGN KEY (TransferID) REFERENCES AnaDepoMagazaTransferleri(TransferID),
    FOREIGN KEY (UrunID) REFERENCES Urun(UrunID)
);

CREATE TABLE AnaDepoHareketleri (
    HareketID NUMBER DEFAULT AnaDepoHareketIDSeq.NEXTVAL PRIMARY KEY,
    HareketTarihi DATE,
    IslemTur NUMBER(1)
);

CREATE TABLE AnaUrunHareket (
    HareketID NUMBER,
    UrunID NUMBER,
    Adet NUMBER,
    IslemTur NUMBER(1),
    FOREIGN KEY (HareketID) REFERENCES AnaDepoHareketleri(HareketID),
    FOREIGN KEY (UrunID) REFERENCES Urun(UrunID)
);
CREATE TABLE MagazaHareketleri (
    HareketID NUMBER,
    UrunID NUMBER,
    Adet NUMBER,
    FOREIGN KEY (HareketID) REFERENCES MagazaStokHareketleri(StokHareketID),
    FOREIGN KEY (UrunID) REFERENCES Urun(UrunID)
);
CREATE TABLE MagazaStokHareketleri (
    StokHareketID NUMBER DEFAULT MagazaStokHareketIDSeq.NEXTVAL PRIMARY KEY,
    HareketTarihi DATE,
    IslemTur NUMBER(1)
);