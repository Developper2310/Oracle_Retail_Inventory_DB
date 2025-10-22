-- Trigger: TRG_TransferUrunleri
CREATE OR REPLACE TRIGGER TRG_TransferUrunleri
AFTER INSERT ON TransferUrunleri
FOR EACH ROW
DECLARE
    v_StokMiktari NUMBER;
    v_IslemTur NUMBER;
 BEGIN
    SELECT MU.StokMiktari, AT.IslemTur
    INTO v_StokMiktari, v_IslemTur
    FROM MagazaUrunleri MU
    JOIN AnaDepoMagazaTransferleri AT ON MU.MagazaID = AT.MagazaID
    WHERE MU.UrunID = :NEW.UrunID AND AT.TransferID = :NEW.TransferID;

    IF v_IslemTur = 1 THEN
        UPDATE MagazaUrunleri
        SET StokMiktari = v_StokMiktari + :NEW.Adet
        WHERE UrunID = :NEW.UrunID;
 UPDATE AnaDepoUrunleri
        SET StokMiktari = StokMiktari - :NEW.Adet
        WHERE UrunID = :NEW.UrunID;
 ELSIF v_IslemTur = 0 THEN
        UPDATE MagazaUrunleri
        SET StokMiktari = v_StokMiktari - :NEW.Adet
        WHERE UrunID = :NEW.UrunID;
 UPDATE AnaDepoUrunleri
        SET StokMiktari = StokMiktari + :NEW.Adet
        WHERE UrunID = :NEW.UrunID;
 END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hata: ' || SQLERRM);
 END;
/
	

-----AUH Trigger i_------------------------------------
CREATE OR REPLACE TRIGGER TRG_ANAURUNHAREKET
BEFORE INSERT ON AnaUrunHareket
FOR EACH ROW
DECLARE
    v_IslemTur NUMBER;
 BEGIN
    SELECT IslemTur INTO v_IslemTur
    FROM AnaDepoHareketleri
    WHERE HareketID = :NEW.HareketID;

    UPDATE AnaDepoUrunleri
    SET StokMiktari = StokMiktari + CASE WHEN v_IslemTur = 1 THEN :NEW.Adet ELSE - :NEW.Adet END
    WHERE UrunID = :NEW.UrunID;
 END;
/

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< TRG_MAGAZAHAREKET >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CREATE OR REPLACE TRIGGER TRG_MAGAZAHAREKET
AFTER INSERT ON MagazaHareketleri
FOR EACH ROW
DECLARE
    v_StokMiktari NUMBER;
    v_IslemTur NUMBER;
 v_MagazaID NUMBER;
BEGIN
    SELECT IslemTur, MagazaID
    INTO v_IslemTur, v_MagazaID
    FROM MagazaStokHareketleri
    WHERE StokHareketID = :NEW.HareketID;
 UPDATE MagazaUrunleri
    SET StokMiktari = StokMiktari + CASE WHEN v_IslemTur = 1 THEN :NEW.Adet ELSE - :NEW.Adet END
    WHERE UrunID = :NEW.UrunID AND MagazaID = v_MagazaID;
 DBMS_OUTPUT.PUT_LINE('IslemTur: ' || v_IslemTur || ', MagazaID: ' || v_MagazaID);
 EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hata: ' || SQLERRM);
END;
 /


<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< TRG_TransferUrunleri>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


CREATE OR REPLACE TRIGGER TRG_TransferUrunleri
AFTER INSERT ON TransferUrunleri
FOR EACH ROW
DECLARE
    v_StokMiktari NUMBER;
    v_IslemTur NUMBER;
 BEGIN
    SELECT MU.StokMiktari, AT.IslemTur
    INTO v_StokMiktari, v_IslemTur
    FROM MagazaUrunleri MU
    JOIN AnaDepoMagazaTransferleri AT ON MU.MagazaID = AT.MagazaID
    WHERE MU.UrunID = :NEW.UrunID AND AT.TransferID = :NEW.TransferID;

    IF v_IslemTur = 1 THEN
        UPDATE MagazaUrunleri
        SET StokMiktari = v_StokMiktari + :NEW.Adet
        WHERE UrunID = :NEW.UrunID;
 UPDATE AnaDepoUrunleri
        SET StokMiktari = StokMiktari - :NEW.Adet
        WHERE UrunID = :NEW.UrunID;
 ELSIF v_IslemTur = 0 THEN
        UPDATE MagazaUrunleri
        SET StokMiktari = v_StokMiktari - :NEW.Adet
        WHERE UrunID = :NEW.UrunID;
 UPDATE AnaDepoUrunleri
        SET StokMiktari = StokMiktari + :NEW.Adet
        WHERE UrunID = :NEW.UrunID;
 END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hata: ' || SQLERRM);
 END;
/