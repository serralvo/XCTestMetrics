import Foundation

final class StyleFile {
    
    static let content =
    """
body {
  font-family: sans-serif;
}

table {
  border-collapse: collapse;
  width: 100%;
  border: 1px solid #ececec;
}

table tbody tr td {
  padding: 10px;
  font-size: 14px;
}

.head {
  background-color: #2ecc71 !important;
  color: #fff;
  font-size: 15px;
  font-weight: bold;
}

tr:nth-child(even) {
  background: #ececec
}

tr:nth-child(odd) {
  background: #FFF
}

.summary {
  width: 100%;
  height: 50px;
  border: 1px solid #2ecc71;
}

.summary .item {
  float: left;
  width: 25%;
}

.summary .highlight {
  float: left;
  width: 25%;
  background-color: #2ecc71;
  color: #fff;
  text-align: center;
  font-weight: bold;
}

.summary .item .title p, .summary .item .subtitle p {
  margin: 0px;
  width: 100%;
  float: left;
}

.summary .item .title {
  width: 100%;
  height: 20px;
  margin-top: 7px;
  text-align: center;
  color: #6c7a89;
  font-size: 14px;
}

.summary .item .subtitle {
  height: 30px;
  width: 100%;
  text-align: center;
  color: #2e3131;
  font-weight: bold;
}
"""
    
}
