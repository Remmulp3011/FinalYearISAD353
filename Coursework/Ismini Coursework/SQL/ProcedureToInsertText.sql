--CREATE IMAGE INTO TABLE
DECLARE
  l_name VARCHAR2(100);
  l_description VARCHAR2(1000);

BEGIN


  --
  -- Insert a new row into the table, initialising the image and
  -- returning the newly allocated image_id for later use
  --
  INSERT
  INTO
    LANDMARK_INFORMATION_V2
    (
      landmark_description,
      landmark_name
    )
    VALUES
    (
     :P3_LANDMARK_NAME,
     :P3_LANDMARK_DESCRIPTION
    )
  RETURNING
    landmark_name, landmark_description
  INTO
    l_name, l_description;
END;
