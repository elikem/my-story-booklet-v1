[![Code Climate](https://codeclimate.com/github/elikem/my-story-booklet/badges/gpa.svg)](https://codeclimate.com/github/elikem/my-story-booklet)


My Story Booklet
================

My Story Booklet automates the insertion of a personal story into the My Story
Booklet. The app generates an IDML (InDesign document) that can be sent off to
professional printers.

 

Getting up and running
----------------------

There’s nothing outside of the usual Rails process to run the app.

Don't forget to add env vars to \`secrets.example.yml\` as a template for
your own \`secrets.yml\`.

 

Software notes
--------------

Model \`in\_design\_doc\` has a field \`status\` with the following states in
the following order [generate_pdf_ebook | notify_user | complete | invalid]