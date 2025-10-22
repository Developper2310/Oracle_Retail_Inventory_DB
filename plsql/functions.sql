------------------<<<<<<<<<<<<<<<<  StokYeterliMi  >>>>>>>>>>>>>>>>>>>>
CREATE OR REPLACE FUNCTION StokYeterliMi (
    p_UrunID NUMBER,
    p_Adet NUMBER,
    p_HareketID NUMBER
) RETURN BOOLEAN AS
    v_StokMiktari NUMBER;
 BEGIN
    
    SELECT StokMiktari INTO v_StokMiktari
    FROM AnaDepoUrunleri
    WHERE UrunID = p_UrunID;
    IF v_StokMiktari < p_Adet THEN
        DBMS_OUTPUT.PUT_LINE('Hata: Stok miktarı yetersiz!');
 RETURN FALSE;
    END IF;

    IF p_HareketID = 0 THEN
        RETURN TRUE;
 END IF;

    SELECT SUM(Adet) INTO v_StokMiktari
    FROM AnaUrunHareket
    WHERE UrunID = p_UrunID AND HareketID = p_HareketID;
 RETURN v_StokMiktari >= p_Adet;
END StokYeterliMi;
/

------------------<<<<<<<<<<<<<<<< UrunKaydiVarMi >>>>>>>>>>>>>>>>>>>>
CREATE OR REPLACE FUNCTION UrunKaydiVarMi (
    p_UrunID NUMBER
) RETURN BOOLEAN AS
    v_UrunSayisi NUMBER;
 BEGIN

    SELECT COUNT(*)
    INTO v_UrunSayisi
    FROM AnaDepoUrunleri
    WHERE UrunID = p_UrunID;
 RETURN v_UrunSayisi > 0;
END UrunKaydiVarMi;
/

--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<MagazaStokYeterliMi >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CREATE OR REPLACE FUNCTION MagazaStokYeterliMi (
    p_UrunID NUMBER,
    p_Adet NUMBER,
    p_MagazaID NUMBER,
    p_HareketID NUMBER
) RETURN BOOLEAN AS
    v_StokMiktari NUMBER;
 v_Urun VARCHAR2(255);
BEGIN
    SELECT StokMiktari, UrunAdi INTO v_StokMiktari, v_Urun
    FROM MagazaUrunleri
    JOIN Urun ON MagazaUrunleri.UrunID = Urun.UrunID
    WHERE MagazaUrunleri.UrunID = p_UrunID AND MagazaUrunleri.MagazaID = p_MagazaID;

    IF p_HareketID = 1 THEN
        RETURN TRUE;
 END IF;

    IF v_StokMiktari < p_Adet THEN
        DBMS_OUTPUT.PUT_LINE('Hata: Stok miktarı yetersiz! Urun Adı: ' || v_Urun || ', Mevcut Stok: ' || v_StokMiktari || ', Çıkarılmak istenen: '|| p_Adet);
 RETURN FALSE;
    END IF;

    SELECT SUM(Adet) INTO v_StokMiktari
    FROM MagazaHareketleri
    WHERE UrunID = p_UrunID AND HareketID = p_HareketID;
 RETURN v_StokMiktari >= p_Adet;
END MagazaStokYeterliMi;
/

--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< MagazaUrunKaydiVarMi >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE OR REPLACE FUNCTION MagazaUrunKaydiVarMi (
    p_UrunID NUMBER,
    p_MagazaID NUMBER
) RETURN BOOLEAN AS
    v_UrunSayisi NUMBER;
 BEGIN
    SELECT COUNT(*)
    INTO v_UrunSayisi
    FROM MagazaUrunleri
    WHERE UrunID = p_UrunID AND MagazaID = p_MagazaID;

    RETURN v_UrunSayisi > 0;
END MagazaUrunKaydiVarMi;
 /

      -- Fonksiyon: TransferStokYeterliMi---------------------------------------
CREATE OR REPLACE FUNCTION TransferStokYeterliMi (
    p_UrunID NUMBER,
    p_Adet NUMBER,
    p_MagazaID NUMBER,
    p_TransferTur NUMBER
) RETURN BOOLEAN AS
    v_HedefMagazaID NUMBER;
 BEGIN


    IF p_TransferTur = 0 THEN
        RETURN StokYeterliMi(p_UrunID, p_Adet,0);
    ELSIF p_TransferTur = 1 THEN
        RETURN MagazaStokYeterliMi(p_UrunID, p_Adet, p_MagazaID, 0);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hata: ' || SQLERRM);
 RETURN FALSE;
END TransferStokYeterliMi;
/

    --------------------------------------------------
    
CREATE OR REPLACE FUNCTION TransferUrunKaydiVarMi (
    p_UrunID NUMBER,
    p_TransferID NUMBER
) RETURN BOOLEAN AS
    v_UrunSayisi NUMBER;
 v_MagazaID NUMBER;
BEGIN
    SELECT  MagazaID
    INTO  v_MagazaID
    FROM AnaDepoMagazaTransferleri
    WHERE  TransferID = p_TransferID;

    IF v_UrunSayisi > 0 THEN
        IF NOT MagazaUrunKaydiVarMi(p_UrunID, v_MagazaID) THEN
            DBMS_OUTPUT.PUT_LINE('Hata: MagazaUrunleri kaydı bulunamadı. Yeni kayıt oluşturuluyor...');
 INSERT INTO MagazaUrunleri (MagazaID, UrunID, StokMiktari)
            VALUES (v_MagazaID, p_UrunID, 0);
 END IF;

        IF NOT UrunKaydiVarMi(p_UrunID) THEN
            DBMS_OUTPUT.PUT_LINE('Hata: AnadepoUrunleri kaydı bulunamadı. Yeni kayıt oluşturuluyor...');
 INSERT INTO AnadepoUrunleri (UrunID, StokMiktari)
            VALUES (p_UrunID, 0);
 END IF;

        RETURN TRUE;
    ELSE
        RETURN TRUE;

    END IF;
END TransferUrunKaydiVarMi;
 /