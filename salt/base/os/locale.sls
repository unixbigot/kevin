au_locale:
  locale.present:
    - name: en_AU.UTF-8

default_locale:
  locale.system:
    - name: en_AU.UTF-8
    - require:
      - locale: au_locale
    