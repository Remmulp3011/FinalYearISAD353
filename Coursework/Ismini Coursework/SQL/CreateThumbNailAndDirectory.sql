--CREATE A DIRECTORY FOR THE IMAGES
CREATE OR REPLACE DIRETORY LANDMARK_IMAGES AS '/Users/matthewplummer/Documents/FinalYearRepos/FinalYearISAD353/Coursework/Ismini Coursework/LandmarkImages';

GRANT READ ON DIRECTORY LANDMARK_IMAGES TO PUBLIC;

--PROCEDURE TO SHOW THE THUMBNAIL
CREATE OR REPLACE PROCEDURE load_image_from_file
(p_filename IN VARCHAR2) AS

 l_image_id INTEGER;
 l_image    ORDSYS.ORDImage;
 ctx        RAW (64) := NULL;

BEGIN
  INSERT INTO LANDMARK_INFORMATION_V2
    (
     info_id,
     filename,
     image
    )
  VALUES
    (
     seq_info_id.nextval,
     p_filename,
     ORDSYS.ORDImage
       ('FILE',
        'ISAD353_IMAGES',
        p_filename,
        1 -- setProperties, default is 0
       )
    )
  RETURNING info_id, image INTO l_image_id, l_image;
  -- useful INSERT variant

  l_image.import(ctx);

  -- explicit property setting if needed
  -- l_image.setProperties();

  UPDATE LANDMARK_INFORMATION_V2
  SET image = l_image
  WHERE info_id = l_image_id;

  COMMIT;

  EXCEPTION
  WHEN others THEN
    BEGIN
      ROLLBACK;
      dbms_output.put_line(sqlerrm);
    END;

END;
