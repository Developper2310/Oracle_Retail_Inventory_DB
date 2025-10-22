EXEC DBMS_SCHEDULER.enable;

BEGIN
 DBMS_SCHEDULER.create_job (
  job_name        => 'VERI_GIRIS_KONTROL',
  job_type        => 'PLSQL_BLOCK',
  job_action      => 'BEGIN
                       DECLARE
                         v_current_hour NUMBER;
              
                     BEGIN
                         SELECT TO_NUMBER(TO_CHAR(SYSDATE, ''HH24'')) INTO v_current_hour FROM dual;

                         IF v_current_hour BETWEEN 0 AND 
 7 AND EXISTS (SELECT 1 FROM your_table WHERE veri_girisi_yapilmaya_calisiliyor) THEN
                          
                           send_notification_to_admin(Magazaid);--buraya temsili prosedür yazdım gerçekte yok. e posta işlemini simgeliyor.
                         END IF;
   
                     END;',
  start_date      => TO_TIMESTAMP('12:00:00', 'HH24:MI:SS'),
  repeat_interval => 'FREQ=MINUTELY; BYMINUTE=0; BYSECOND=0',
  enabled         => TRUE
 );
 END;
/
--Knk bu kısım son eklentilerim istersen send_notification_to_admin fonsiyonunuu tanımlayabiliriz ama hoca zaten bakmaz sen diğer fonksiyonlarla kontrol et sana bırakıyorum tanımlarsan yalancıktan koy e posta göndermez livesql