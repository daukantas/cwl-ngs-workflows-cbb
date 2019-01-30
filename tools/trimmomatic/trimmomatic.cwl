#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: echo
doc: |
  Trimmomatic is a fast, multithreaded command line tool that can be used to trim and crop
  Illumina (FASTQ) data as well as to remove adapters

hints:
- $import: trimmomatic.yml

requirements:
  SchemaDefRequirement:
    types:
    - $import: trimmomatic-end_mode.yaml
    - $import: trimmomatic-sliding_window.yaml
    - $import: trimmomatic-phred.yaml
    - $import: trimmomatic-illumina_clipping.yaml
    - $import: trimmomatic-max_info.yaml
  InlineJavascriptRequirement: {}
  ShellCommandRequirement: {}

inputs:
  end_mode:
    type: string
    inputBinding:
      position: 1
    doc: |
      Single End (SE) or Paired End (PE) mode
  threads:
    type: int
    inputBinding:
      prefix: -threads
      position: 2
  phred:
    type: int?
    inputBinding:
      prefix: -phred
      separate: false
      position: 3
    doc: |
      "33" or "64" specifies the base quality encoding. Default: 64
  reads1:
    type: File
    inputBinding:
      position: 4
    doc: FASTQ file of reads (R1 reads in Paired End mode)
  reads2:
    type: File?
    inputBinding:
      position: 5
    doc: FASTQ file of R2 reads in Paired End mode
  reads1_out:
    type: string
    inputBinding:
      position: 6
  reads1_out2:
    type: string?
    inputBinding:
      position: 7
  reads2_out:
    type: string?
    inputBinding:
      position: 8
  reads2_out2:
    type: string?
    inputBinding:
      position: 9

  illuminaClip:
    type: string?
    inputBinding:
      position: 11
      valueFrom: |
        ${
            return 'ILLUMINACLIP:/usr/local/share/trimmomatic/adapters/' + self;
         }
    doc: Cut adapter and other illumina-specific sequences from the read.
  tophred64:
    type: boolean?
    inputBinding:
      position: 12
      prefix: TOPHRED64
      separate: false
    doc: This (re)encodes the quality part of the FASTQ file to base 64.
  tophred33:
    type: boolean?
    inputBinding:
      position: 12
      prefix: TOPHRED33
      separate: false
    doc: This (re)encodes the quality part of the FASTQ file to base 33.
  slidingwindow:
    type: trimmomatic-sliding_window.yaml#slidingWindow?
    inputBinding:
      position: 15
      valueFrom: |
        ${ if ( self ) {
             return "SLIDINGWINDOW:" + self.windowSize + ":"
               + self.requiredQuality;
           } else {
             return self;
           }
         }
    doc: |
      Perform a sliding window trimming, cutting once the average quality
      within the window falls below a threshold. By considering multiple
      bases, a single poor quality base will not cause the removal of high
      quality data later in the read.
      <windowSize> specifies the number of bases to average across
      <requiredQuality> specifies the average quality required
  maxinfo:
    type: trimmomatic-max_info.yaml#maxinfo?
    inputBinding:
      position: 15
      valueFrom: |
        ${ if ( self ) {
             return "MAXINFO:" + self.targetLength + ":" + self.strictness;
           } else {
             return self;
           }
         }
    doc: |
      Performs an adaptive quality trim, balancing the benefits of retaining
      longer reads against the costs of retaining bases with errors.
      <targetLength>: This specifies the read length which is likely to allow
      the location of the read within the target sequence to be determined.
      <strictness>: This value, which should be set between 0 and 1, specifies
      the balance between preserving as much read length as possible vs.
      removal of incorrect bases. A low value of this parameter (<0.2) favours
      longer reads, while a high value (>0.8) favours read correctness.

  crop:
    type: int?
    inputBinding:
      position: 20
      prefix: 'CROP:'
      separate: false
    doc: |
      Removes bases regardless of quality from the end of the read, so that the
      read has maximally the specified length after this step has been
      performed. Steps performed after CROP might of course further shorten the
      read. The value is the number of bases to keep, from the start of the read.
  headcrop:
    type: int?
    inputBinding:
      position: 21
      prefix: 'HEADCROP:'
      separate: false
    doc: |
      Removes the specified number of bases, regardless of quality, from the
      beginning of the read.
      The numbser specified is the number of bases to keep, from the start of
      the read.

  leading:
    type: int?
    inputBinding:
      position: 22
      prefix: 'LEADING:'
      separate: false
    doc: |
      Remove low quality bases from the beginning. As long as a base has a
      value below this threshold the base is removed and the next base will be
      investigated.
  trailing:
    type: int?
    inputBinding:
      position: 23
      prefix: 'TRAILING:'
      separate: false
    doc: |
      Remove low quality bases from the end. As long as a base has a value
      below this threshold the base is removed and the next base (which as
      trimmomatic is starting from the 3' prime end would be base preceding
      the just removed base) will be investigated. This approach can be used
      removing the special Illumina "low quality segment" regions (which are
      marked with quality score of 2), but we recommend Sliding Window or
      MaxInfo instead
  avgqual:
    type: int?
    inputBinding:
      position: 24
      prefix: 'AVGQUAL:'
      separate: false
    doc: |
      Drop the read if the average quality is below the specified level
  minlen:
    type: int?
    inputBinding:
      position: 25
      prefix: 'MINLEN:'
      separate: false
    doc: |
      This module removes reads that fall below the specified minimal length.
      If required, it should normally be after all other processing steps.
      Reads removed by this step will be counted and included in the "dropped
      reads" count presented in the trimmomatic summary.

outputs:
  reads1_trimmed:
    type: File
    outputBinding:
      glob: $(inputs.reads1_out)
  reads2_trimmed:
    type: File?
    outputBinding:
      glob: $(inputs.reads2_out)

baseCommand: [ 'trimmomatic']

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-4108-5982
    s:email: mailto:r78v10a07@gmail.com
    s:name: Roberto Vera Alvarez

s:codeRepository: https://github.com/alexdobin/STAR
s:license: https://spdx.org/licenses/OPL-1.0

$namespaces:
  edam: http://edamontology.org/
  s: http://schema.org/

$schemas:
- http://edamontology.org/EDAM_1.16.owl
- https://schema.org/docs/schema_org_rdfa.html
