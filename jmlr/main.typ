#import "/jmlr.typ": jmlr
#import "/blindtext.typ": blindtext, blindmathpaper

#show: jmlr.with(
  title: [Sample JMLR Paper],
  keywords: ("keyword one", "keyword two", "keyword three"),
  abstract: blindtext,
  bibliography: bibliography("main.bib"),
  appendix: include "appendix.typ",
)

= Introduction

#blindmathpaper

Here is a citation @chow68.

= Acknowledgments and Disclosure of Funding

All acknowledgements go at the end of the paper before appendices and
references. Moreover, you are required to declare funding (financial activities
supporting the submitted work) and competing interests (related financial
activities outside the submitted work). More information about this disclosure
can be found on the JMLR website.
