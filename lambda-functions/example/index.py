from sqlalchemy import create_engine, MetaData, Table


def lambda_handler(event, context):
    # Define your connection string (modify this to match your database)
    # Example for a PostgreSQL database:
    connection_string = (
        "postgresql+psycopg2://username:password@localhost:5432/mydatabase"
    )

    # Create an engine
    engine = create_engine(connection_string)

    # Initialize the metadata object
    metadata = MetaData()

    # Reflect the tables
    metadata.reflect(bind=engine)

    # Print out the tables and their columns
    for table_name in metadata.tables:
        table = metadata.tables[table_name]
        print(f"Table: {table_name}")
        for column in table.columns:
            print(f"Column: {column.name} - Type: {column.type}")

    # Alternatively, you can access a specific table and inspect its columns
    # table_name = 'your_table_name'
    # table = Table(table_name, metadata, autoload_with=engine)
    # print(f"Table: {table_name}")
    # for column in table.columns:
    #     print(f"Column: {column.name} - Type: {column.type}")


# Example event for local testing
if __name__ == "__main__":
    # Example POST request
    event_post = {
        "example": "POST",
    }
    context = {}
    print(lambda_handler(event_post, context))
