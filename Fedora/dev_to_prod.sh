# Replace <model> by appropriate model
# Replace <project> by appropriate yii2 advanced project

cp /c/LEO/xampp/htdocs/<project>_development/common/models/<model>.php /c/LEO/xampp/htdocs/<project>_prod/common/models/

cp /c/LEO/xampp/htdocs/<project>_development/common/models/query/<model>.php /c/LEO/xampp/htdocs/<project>_prod/common/models/query/

cp /c/LEO/xampp/htdocs/<project>_development/backend/controllers/<model>Controller.php /c/LEO/xampp/htdocs/<project>_prod/backend/controllers/

cp -r /c/LEO/xampp/htdocs/<project>_development/backend/views/<model>/ /c/LEO/xampp/htdocs/<project>_prod/backend/views/

cd /c/LEO/xampp/htdocs/<project>_prod/

git add .

git commit -m "[Batch] CRUD complete added!"

git push
