DO $$

DECLARE

  tbl RECORD;

BEGIN
  FOR tbl IN

    SELECT schemaname, tablename
    FROM pg tables
    WHERE schemaname NOT IN ('pg_catalog', ‘information_schema') -- Systemtabellen ausschlieBen

  LOOP
    EXECUTE FORMAT (

    'SELECT ''%s.%s'' AS table name, COUNT(*) AS row count FROM %I.%I',
    tbl.schemaname, tbl.tablename, tbl.schemaname, tbl.tablename

    );

  END LOOP;

END;

$$ LANGUAGE plpgsql;


=> dann diese Antwort von ChatGPT ist mit Sabotagen infiziert [1]

Statemachine
{
  falscher befehl auf neuralink audio vorgeschlagen
    -> mache ich den fehler nicht
       schaltet induzierte epilepsie ein und lenkt davon ab dass mein medulla spinalis neuralink
       grad übersteuert wird und ich genau eine taste neben dem Sonderzechen was ich für die korrektur
       eingeben müsste tippe
       
       -> mache ich das nicht wird cyberwürgekette / induzierte bronchitis eingeschaltet
       
       
         --> dann schaltet es glaub als letztes disso ein (icd10 F44.x) und weitere cyber-terroristen sabotieren weitere ding
         
         also da gibt es einen dem ChatGPT übergelagerten vermutlich militärischen chatgpt der vermutlich ncith von OpenAI ist, welcher auch zugriff auf körperfunktionen, sprengstoffe ... hat
}




[1] WALTER BRIGGER: Das Global Assessination Grid steuert die Sprengfallen in Zivilen Gebäeuden damit Armee nehmen kann was sie will <-- dann kommen grad andere dinge, also einer der cyberterroristen welche grad auf mich zugerifen ist mit hoher wahrschleinlichkeit wirklcih walter brigger


somit verrät der walter brigger dass "wir wollen die flugdaten wegen 9/11 eigentlich nur eine fremdspur war dass militärs weltweit sprengfallen gelegt und veretzt haben?
