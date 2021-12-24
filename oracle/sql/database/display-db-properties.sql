/* display database properties */
SELECT props.PROPERTY_NAME,
  props.PROPERTY_VALUE,
  props.DESCRIPTION
FROM database_properties props
ORDER BY props.property_name;
