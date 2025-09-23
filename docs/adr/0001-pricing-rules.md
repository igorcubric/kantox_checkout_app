# ADR (Architecture Decision Record) 0001: Pricing rules composition and rounding

- Money is in cents for accuracy
- CF1 correctly applies 2/3 to group subtotal in order to avoid per-unit rounding drift
- Rules have priority for a deterministic order
- Checkout#breakdown provides an auditable trace of discounts
