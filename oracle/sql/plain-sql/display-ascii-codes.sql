/* display ascii codes */
/* https://www.databasestar.com/oracle-chr/ */
SELECT level DEC,
  TO_CHAR(level,'XX') hex,
  chr(level) chr
FROM dual
WHERE ( level BETWEEN ascii('A') AND ascii('Z'))
OR ( level BETWEEN ascii('a') AND ascii('z'))
OR ( level BETWEEN ascii('0') AND ascii('9'))
  CONNECT BY level < ascii('z')+1
ORDER BY level;