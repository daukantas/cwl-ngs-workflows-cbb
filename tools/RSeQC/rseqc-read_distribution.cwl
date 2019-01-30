#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: RSeQC-read_distribution
doc: RSeQC package provides a number of useful modules that can comprehensively evaluate high throughput sequence data especially RNA-seq data

requirements:
  - class: InlineJavascriptRequirement
  - $import: rseqc.yml

inputs:
  o:
    type: string
  i:
    type: File
    inputBinding:
      position: 1
      prefix: -i
  r:
    type: File
    inputBinding:
      position: 2
      prefix: -r

outputs:
  output:
    type: stdout

stdout: $(inputs.o)

baseCommand: [read_distribution.py]

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-4108-5982
    s:email: mailto:r78v10a07@gmail.com
    s:name: Roberto Vera Alvarez

s:codeRepository: http://rseqc.sourceforge.net
s:license: https://spdx.org/licenses/OPL-1.0

$namespaces:
  s: http://schema.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
