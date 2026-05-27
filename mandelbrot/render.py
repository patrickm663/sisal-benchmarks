import sys

def map_to_ascii(val):
    if val == 10000:
        return "██"  # Inside the set (stable)
    elif val > 50:
        return "▓▓"  # Deep border
    elif val > 20:
        return "▒▒"  # Mid border
    elif val > 7:
        return "░░"  # Outer border
    elif val > 2:
        return "::"  # Escaped quickly
    else:
        return "  "  # Escaped immediately (empty space)

# Process standard input line by line
for line in sys.stdin:
    # Look for Sisal's array output pattern
    if "[" in line and ":" in line and "]" in line:
        try:
            # Extract just the sequence of numbers
            numbers_str = line.split(":")[1].split("]")[0]
            # Convert to integers
            numbers = [int(n) for n in numbers_str.split() if n.isdigit()]
            
            # Map numbers to ASCII and print the row
            ascii_row = "".join(map_to_ascii(n) for n in numbers)
            if ascii_row:
                print(ascii_row)
        except Exception:
            pass # Ignore malformed lines like the compilation header
