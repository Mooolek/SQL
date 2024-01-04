SELECT DISTINCT
         CRHD.CPLGR                             AS 'Wydzial',
         substring(AFKO.AUFNR,3,10)		AS 'Numer zlecenia',
         MATERIALID.MATNR_EXT			AS 'Numer czêœci',
         MAKT.MAKTX                             AS 'Opis czêœci',
         AFPO.LTRMI				AS 'Data zakończenia zlecenia (DSTR)', 
         AFVC.VORNR                             AS 'Numer operacji',
         CRHD2.ARBPL                            AS 'St. robocze',
         CRHD2.CPLGR                            AS 'Cen. st. robocz',
         CRHD2.SORTB                            AS 'Plac. st. robocz',
         CRTX.KTEXT                             AS 'Opis st. robocz',
         AFKO.GAMNG                             AS 'Ilosc',
         AFVC.STEUS                             AS 'Klucz sterowania',
         AFRU.IEDD                              AS 'Data potwierdzenia',
         AFRU.IEDZ                              AS 'Godzina potwierdzenia',
         AFRU.PERNR                             AS 'Numer osobowy',
         AFRU.ERNAM                             AS 'Numer osobowy QA',
         AFRU.EXNAM                             
FROM        Z_R3_AFKO_TBL AFKO
INNER JOIN [Z_R3_AFPO_TBL] AFPO ON AFKO.AUFNR = AFPO.AUFNR
INNER JOIN  Z_R3_MARC_TBL MARC ON AFKO.PLNBEZ = MARC.MATNR AND MARC.MANDT = '500'
INNER JOIN  Z_R3_MATERIALID_TBL MATERIALID ON MARC.MATNR = MATERIALID.MATNR_INT  AND MATERIALID.MANDT = '500'
INNER JOIN  Z_R3_CRHD_TBL CRHD ON MARC.ZZMSRC = CRHD.ARBPL AND CRHD.MANDT = '500'
INNER JOIN  Z_R3_MAKT_TBL MAKT ON MARC.MATNR = MAKT.MATNR AND MAKT.MANDT = '500'
INNER JOIN  Z_R3_AFVC_TBL AFVC ON AFKO.AUFPL = AFVC.AUFPL AND AFVC.MANDT = '500'
/*INNER JOIN      Z_R3_AFVV_TBL AFVV ON AFVC.AUFPL = AFVV.AUFPL AND AFVC.APLZL = AFVV.APLZL AND AFVV.MANDT = '500'*/
INNER JOIN  Z_R3_CRHD_TBL CRHD2 ON AFVC.ARBID = CRHD2.OBJID AND CRHD2.MANDT = '500'
INNER JOIN  Z_R3_CRTX_TBL CRTX ON CRHD2.OBJID = CRTX.OBJID AND CRTX.MANDT = '500'
INNER JOIN  Z_R3_AFRU_TBL AFRU ON AFVC.AUFPL = AFRU.AUFPL AND AFVC.APLZL = AFRU.APLZL AND AFVC.MANDT = '500'
LEFT JOIN  Z_R3_PA0001_TBL PA0001 ON AFRU.PERNR = PA0001.PERNR AND PA0001.MANDT = '500'
LEFT JOIN  Z_SOL_SACC_EMPLY_HIERARCHY_TBL AS EMPLY ON PA0001.MSTBR = EMPLY.EMPLID
WHERE    
		CRHD.CPLGR = 'W30'
        AND MAKT.SPRAS = 'E' 
        AND CRTX.SPRAS = 'L' 
        --czy zakończone technicznie
		--AND AFPO.DNREL IS NULL 
		
		--czy zakończone
		--AND AFPO.ELIKZ IS NULL
		
		--data zakończenia przewodnika
		AND (AFPO.LTRMI >= '2015-04-01' OR AFPO.ELIKZ IS NULL)
		             
ORDER BY CRHD.CPLGR, [Numer zlecenia], [Numer operacji]
