/* NLS parameters */
SELECT 'SESSION' source, parameter, value FROM nls_session_parameters
UNION
SELECT 'INSTANCE' source, parameter, value FROM nls_instance_parameters
UNION
SELECT 'DATABASE' source, parameter, value FROM nls_database_parameters
ORDER BY 1 DESC, 2;
