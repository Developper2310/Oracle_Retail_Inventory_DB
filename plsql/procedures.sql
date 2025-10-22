-- ADH-AUH procedure--------------------->><<---------------

CREATE OR REPLACE PROCEDURE AnaDepoHareketEkle (
    p_UrunAdetListesi SYS.ODCIVARCHAR2LIST,
    p_IslemTur NUMBER
) AS
    v_HareketID NUMBER;
 BEGIN
    INSERT INTO AnaDepoHareketleri (HareketID, HareketTarihi, IslemTur)
    VALUES (AnaDepoHareketIDSeq.NEXTVAL, SYSDATE, p_IslemTur)
    RETURNING HareketID INTO v_HareketID;

    FOR i IN 1..p_UrunAdetListesi.COUNT LOOP
        DECLARE
            UrunID NUMBER;
 Adet NUMBER;
        BEGIN
            UrunID := TO_NUMBER(REGEXP_SUBSTR(p_UrunAdetListesi(i), '\d+'));
 Adet := TO_NUMBER(REGEXP_SUBSTR(p_UrunAdetListesi(i), '\d+$'));

            IF NOT UrunKaydiVarMi(UrunID) THEN
                DBMS_OUTPUT.PUT_LINE('Ürün kaydı bulunamadı. Yeni kayıt oluşturuluyor...');
 INSERT INTO AnaDepoUrunleri (UrunID, StokMiktari)
                VALUES (UrunID, 0);
 COMMIT;
            END IF;
			if(p_IslemTur=0)then
            IF NOT StokYeterliMi(UrunID, Adet, v_HareketID) THEN
                DBMS_OUTPUT.PUT_LINE('Hata: Stok miktarı yetersiz!');
 RETURN;
            END IF;
		END IF;

            INSERT INTO AnaUrunHareket (HareketID, UrunID, Adet)
            VALUES (v_HareketID, UrunID, Adet);
 EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Hata: ' || SQLERRM);
 END;
    END LOOP;

    COMMIT;
END AnaDepoHareketEkle;
/

--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< MagazaHareketEkle >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Prosedür---------

CREATE OR REPLACE PROCEDURE MagazaHareketEkle (
    p_UrunAdetListesi SYS.ODCIVARCHAR2LIST,
    p_MagazaID NUMBER,
    p_IslemTur NUMBER
) AS
    v_HareketID NUMBER;
 a_UrunID NUMBER; 
    Adet NUMBER; 
    Urun_ad VARCHAR(50);
BEGIN
    INSERT INTO MagazaStokHareketleri (StokHareketID, HareketTarihi, IslemTur,MagazaID)
    VALUES (HAREKETID_SEQUENCE.NEXTVAL, SYSDATE, p_IslemTur,p_MagazaID)
    RETURNING StokHareketID INTO v_HareketID;

    FOR i IN 1..p_UrunAdetListesi.COUNT LOOP
        BEGIN
            a_UrunID := TO_NUMBER(REGEXP_SUBSTR(p_UrunAdetListesi(i), '\d+'));
 Adet := TO_NUMBER(REGEXP_SUBSTR(p_UrunAdetListesi(i), '\d+$'));

DBMS_OUTPUT.PUT_LINE( a_UrunID || '  ürünü');

            IF NOT MagazaUrunKaydiVarMi(a_UrunID, p_MagazaID) THEN
                SELECT UrunAdi INTO Urun_ad FROM Urun WHERE UrunID = a_UrunID;
 DBMS_OUTPUT.PUT_LINE(Urun_ad || ' Ürününün kaydı bulunamadı. Yeni kayıt oluşturuluyor...');
                INSERT INTO MagazaUrunleri (MagazaID, UrunID, StokMiktari)
                VALUES (p_MagazaID, a_UrunID, 0);
 END IF;

            if(p_IslemTur=0)then
            IF NOT MagazaStokYeterliMi(a_UrunID, Adet, p_MagazaID, v_HareketID) THEN
                DBMS_OUTPUT.PUT_LINE('Hata: Stok miktarı yetersiz!');
 ROLLBACK;
                RETURN;
            END IF;
            end if;

            INSERT INTO MagazaHareketleri (HareketID, UrunID, Adet)
            VALUES (v_HareketID, a_UrunID, Adet);
 EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Hata: ' || SQLERRM);
 END;
    END LOOP;

    COMMIT;
END MagazaHareketEkle;
/


------------------------------------------------ AnaDepoMagazaTransferEkle ----------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------AnaDepoMagazaTransferEkle ----------------------------------------------------

CREATE OR REPLACE PROCEDURE AnaDepoMagazaTransferEkle (
    p_MagazaID NUMBER,
    p_IslemTur NUMBER,
    p_UrunAdetListesi SYS.ODCIVARCHAR2LIST
) AS
    v_TransferID NUMBER;
 BEGIN
    INSERT INTO AnaDepoMagazaTransferleri (MagazaID, TransferTarihi, IslemTur)
    VALUES (p_MagazaID, SYSDATE, p_IslemTur)
    RETURNING TransferID INTO v_TransferID;

    FOR i IN 1..p_UrunAdetListesi.COUNT LOOP
        DECLARE
            v_UrunID NUMBER;
 v_Adet NUMBER;
        BEGIN
            v_UrunID := TO_NUMBER(REGEXP_SUBSTR(p_UrunAdetListesi(i), '^\d+'));
 v_Adet := TO_NUMBER(REGEXP_SUBSTR(p_UrunAdetListesi(i), '\d+$'));

            IF NOT TransferUrunKaydiVarMi(v_UrunID, v_TransferID) THEN
                DBMS_OUTPUT.PUT_LINE('Hata: TransferUrun kaydı bulunamadı. Yeni kayıt oluşturuluyor...');
 INSERT INTO TransferUrunleri (TransferID, UrunID, Adet)
                VALUES (v_TransferID, v_UrunID, 0);
 END IF;

            IF NOT TransferStokYeterliMi(v_UrunID, v_Adet, p_MagazaID, p_IslemTur) THEN
                DBMS_OUTPUT.PUT_LINE('Hata: Transfer için stok yeterli değil. Transfer iptal ediliyor...');

                RETURN;
 END IF;

            INSERT INTO TransferUrunleri (TransferID, UrunID, Adet)
            VALUES (v_TransferID, v_UrunID, v_Adet);
 EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Hata: ' || SQLERRM);
 END;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hata: ' || SQLERRM);
 END AnaDepoMagazaTransferEkle;
/

---------------------------------------------------------------------------son prosedür------------------------------------------------

CREATE OR REPLACE PROCEDURE MagazaOlmayanUrunleriListele IS
BEGIN
    FOR magaza IN (SELECT * FROM Magaza) LOOP
        DBMS_OUTPUT.PUT_LINE('Magaza ID: ' || magaza.MagazaID || ', Ad: ' || magaza.MagazaAd);
 FOR urun IN (SELECT ADU.UrunID, ADU.StokMiktari
                     FROM AnaDepoUrunleri ADU
                     WHERE NOT EXISTS (SELECT 1 FROM MagazaUrunleri MU WHERE MU.UrunID = ADU.UrunID AND MU.MagazaID = magaza.MagazaID)) LOOP
            DECLARE
                urunadi_c VARCHAR(100);

            BEGIN
              
                SELECT UrunAdi INTO urunadi_c FROM Urun a WHERE a.UrunID = urun.UrunID;
 DBMS_OUTPUT.PUT_LINE('    Urun: ' || urunadi_c || ', mağazada yok: ' || magaza.MagazaAd);
 EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('    Urun: (Bilgi bulunamadı), mağazada yok: ' || magaza.MagazaAd);
 WHEN TOO_MANY_ROWS THEN
                    DBMS_OUTPUT.PUT_LINE('    Urun: (Çok fazla satır bulundu), mağazada yok: ' || magaza.MagazaAd);
 WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('    Hata: ' || SQLERRM);
 END;
        END LOOP;
    END LOOP;
END MagazaOlmayanUrunleriListele;
/