const String createTransactionStateTable = '''
CREATE TABLE IF NOT EXISTS transaction_state (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    state TEXT CHECK (LENGTH(state) <= 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
''';

const String createTransactionTypeTable = '''
CREATE TABLE IF NOT EXISTS transaction_type (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT CHECK (LENGTH(type) <= 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
''';

const String createTransactionCategoryTable = '''
CREATE TABLE IF NOT EXISTS transaction_category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT CHECK (LENGTH(category) <= 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
''';

const String createTransactionTable = '''
CREATE TABLE IF NOT EXISTS transactions (
    idx TEXT PRIMARY KEY,
    date TEXT NOT NULL,
    state INTEGER DEFAULT 1,
    mount REAL NOT NULL,
    description TEXT CHECK (LENGTH(description) <= 700),
    transaction_type_id INTEGER NOT NULL,
    transaction_category_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (state) REFERENCES transaction_state (id),
    FOREIGN KEY (transaction_type_id) REFERENCES transaction_type (id),
    FOREIGN KEY (transaction_category_id) REFERENCES transaction_category (id)
);
''';
