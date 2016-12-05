--创建es_cf表
BEGIN
	EXECUTE IMMEDIATE 'DROP TRIGGER TIB_ES_CF_GOODS';
	EXCEPTION WHEN OTHERS THEN NULL;
END;

BEGIN
	EXECUTE IMMEDIATE 'DROP TABLE ES_CF_GOODS';
	EXCEPTION WHEN OTHERS THEN NULL;
END;

BEGIN
	EXECUTE IMMEDIATE 'DROP SEQUENCE S_ES_CF_GOODS';
	EXCEPTION WHEN OTHERS THEN NULL;
END;

CREATE TABLE ES_CF_GOODS (
  ID NUMBER(38) NOT NULL AUTO_INCREMENT,
  CF_ID NUMBER(38) DEFAULT NULL,
  GOODS_ID NUMBER(38) DEFAULT NULL,
  PRIMARY KEY (ID)
);

CREATE SEQUENCE S_ES_CF_GOODS;

CREATE TRIGGER "TIB_ES_CF_GOODS" BEFORE INSERT
	ON ES_CF_GOODS FOR EACH ROW
	DECLARE
	INTEGRITY_ERROR  EXCEPTION;
	ERRNO            INTEGER;
	ERRMSG           CHAR(200);
	MAXID						 INTEGER;
	BEGIN
		IF :NEW."ID" IS NULL THEN
			SELECT MAX("ID") INTO MAXID FROM ES_CF_GOODS;
			SELECT S_ES_CF_GOODS.NEXTVAL INTO :NEW."ID" FROM DUAL;
			IF MAXID>:NEW."ID" THEN
				LOOP
					SELECT S_ES_CF_GOODS.NEXTVAL INTO :NEW."ID" FROM DUAL;
					EXIT WHEN MAXID<:NEW."ID";
				END LOOP;
			END IF;
		END IF;
	EXCEPTION
		WHEN INTEGRITY_ERROR THEN
			RAISE_APPLICATION_ERROR(ERRNO, ERRMSG);
END;