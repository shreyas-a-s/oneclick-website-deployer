#!/usr/bin/env python3

# Import required modules
import re

# Function definition
def is_db_name_valid(db_name):
  """
  Description: Checks if a given database name is valid.

  Parameters:
  - db_name (str): The name of the database to be validated.

  Returns:
  - bool: True if the name is valid, False otherwise.
  """

  # Check if the length is between 1 and 63 characters
  if not 1 <= len(db_name) <= 63:
    print("Invalid length for database name. It should be 1-63 characters long.")
    return False

  # Check if the first character is a letter or an underscore
  if not re.match(r'^[a-zA-Z_]', db_name):
    print("Database name must start with a letter or underscore.")
    return False

  # Check if subsequent characters are letters, underscores, or digits
  if not re.match(r'^[a-zA-Z_][a-zA-Z0-9_]*$', db_name):
    print("Invalid characters in the database name. It should only contain letters, underscores, and digits.")
    return False

  # If all checks pass, the name is valid
  return True

