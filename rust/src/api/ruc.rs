/// First run of 11 digits in `text` that is a valid RUC: type prefix and
/// check digit (modulo 11)
pub(crate) fn find_ruc(text: &str) -> Option<String> {
    text.split(|character: char| !character.is_ascii_digit())
        .find(|digits| is_ruc(digits))
        .map(String::from)
}

/// Whether `digits` is a valid RUC: 11 digits, type prefix (10, 15, 16, 17
/// or 20) and check digit
#[flutter_rust_bridge::frb(sync)]
pub fn is_ruc(digits: &str) -> bool {
    const WEIGHTS: [u32; 10] = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2];
    let Some(digits) = digits
        .chars()
        .map(|character| character.to_digit(10))
        .collect::<Option<Vec<u32>>>()
    else {
        return false;
    };
    if digits.len() != 11 || ![10, 15, 16, 17, 20].contains(&(digits[0] * 10 + digits[1])) {
        return false;
    }
    let sum: u32 = digits
        .iter()
        .zip(WEIGHTS)
        .map(|(digit, weight)| digit * weight)
        .sum();
    let check = match 11 - sum % 11 {
        10 => 0,
        11 => 1,
        check => check,
    };
    digits[10] == check
}

#[cfg(test)]
mod tests {
    use super::{find_ruc, is_ruc};

    #[test]
    fn find_ruc_skips_numbers_that_are_not_rucs() {
        assert_eq!(
            find_ruc("TEL 51987654321, RUC 20100070970").as_deref(),
            Some("20100070970")
        );
        assert_eq!(find_ruc("20100070971"), None); // wrong check digit
        assert_eq!(find_ruc("DNI 12345678"), None);
    }

    #[test]
    fn is_ruc_checks_prefix_and_check_digit() {
        assert!(is_ruc("10467793549"));
        assert!(!is_ruc("10467793548"));
        assert!(!is_ruc("30467793549"));
        assert!(!is_ruc("1046779354"));
    }
}
