utplsql run app_tester[app]/app_tester@xepdb1 \
    -source_path=src/main -owner=APP \
    -p='app' \
    -test_path=src/test \
    -f=ut_coverage_sonar_reporter     -o=coverage.xml \
    -f=ut_coverage_html_reporter      -o=coverage.html \
    -f=ut_sonar_test_reporter         -o=test_results.xml \
    -f=ut_junit_reporter              -o=junit_test_results.xml \
    -f=ut_documentation_reporter      -o=test_results.log -s
sonar-scanner
